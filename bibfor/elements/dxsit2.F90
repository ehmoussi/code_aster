! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------

subroutine dxsit2(nomte, pgl, sigma)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/dxmat2.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/rccoma.h"
#include "asterfort/rcvarc.h"
#include "asterfort/utmess.h"
    character(len=16) :: nomte
    real(kind=8) :: pgl(3, 3), sigma(*)
!
!     BUT:
!       CALCUL LES CONTRAINTES VRAIES AUX POINTS DE GAUSS
!       RETRANCHE LES CONTRAINTES PLANES D'ORIGINE THERMIQUE AUX POINTS
!       DE GAUSS, POUR LES ELEMENTS COQUES A FACETTES PLANES :
!       DST, DKT, DSQ, DKQ, Q4G DUS :
!       .A UN CHAMP DE TEMPERATURES MOYEN ET
!       .A UN GRADIENT DE TEMPERATURES DANS L'EPAISSEUR DE LA COQUE
!       DANS LE CAS ELASTIQUE ISOTROPE HOMOGENE
!       CAS ELAS_COQMU
!
!     ARGUMENTS:
!     ----------
!
!      ENTREE :
!-------------
! IN   NOMTE    : NOM DU TYPE D'ELEMENT
! IN   PGL(3,3) : MATRICE DE PASSAGE DU REPERE GLOBAL AU REPERE LOCAL
! IN   SIGMA(*) : CONTRAINTES PLANES MECANIQUES AUX POINTS DE GAUSS
!
!      SORTIE :
!-------------
! OUT  SIGMA(*) : CONTRAINTES PLANES VRAIES AUX POINTS DE GAUSS
!
! ......................................................................
!
!
!
!
    integer :: ndim, nno, nnos, npg, ipoids, icoopg, ivf, idfdx, idfd2, jgano
    integer :: iret1, iret2, iret3, iret4, iret5
    integer :: icou, icou2, nbcou, ipg, igauh, npgh, icpg, nbcmp, imoy
    integer :: jnbspi, jmate
    integer :: indith, icodre(1)
!
    real(kind=8) :: dm(3, 3), tref
    real(kind=8) :: tinf(4), tmoy(4), tsup(4)
    real(kind=8) :: ordi, epi, epais, coe1, coe2
!
    character(len=4) :: fami
    character(len=10) :: phenom
!
    aster_logical :: dkg
!
! ----------------------------------------------------------------------
!
! --- INITIALISATIONS :
!     -----------------
    fami = 'RIGI'
    call elrefe_info(fami=fami, ndim=ndim, nno=nno, nnos=nnos, npg=npg,&
                     jpoids=ipoids, jcoopg=icoopg, jvf=ivf, jdfde=idfdx, jdfd2=idfd2,&
                     jgano=jgano)
!
    iret1 = 0
    iret2 = 0
    iret3 = 0
    iret4 = 0
    iret5 = 0
!
    dkg = .false.
!
    if ((nomte.eq.'MEDKTG3') .or. (nomte.eq.'MEDKQG4')) then
        dkg = .true.
    endif
!
! --- RECUPERATION DU NOMBRE DE COUCHE ET DE SOUS-POINT
!     -------------------------------------------------
    if (dkg) then
        nbcou = 1
        npgh = 1
        nbcmp = 6
    else
        call jevech('PNBSP_I', 'L', jnbspi)
        npgh = 3
        nbcou = zi(jnbspi-1+1)
        nbcmp = 6
        if (nbcou .le. 0) then
            call utmess('F', 'ELEMENTS_46')
        endif
    endif
    imoy=(3*nbcou+1)/2
!
! --- RECUPERATION DE LA TEMPERATURE DE REFERENCE
!     -------------------------------------------------
    call rcvarc(' ', 'TEMP', 'REF', 'RIGI', 1,&
                1, tref, iret1)
!     S'IL N'Y A PAS DE TEMPERATURE DE REFERENCE, ON NE FAIT RIEN
    if (iret1 .eq. 1) goto 9999
!
! --- RECUPERATION DE LA TEMPERATURE SUR LES FEUILLETS
!     ------------------------------------------------
    do 5 ipg = 1, npg
        call rcvarc(' ', 'TEMP', '+', 'RIGI', ipg,&
                    1, tinf(ipg), iret2)
        call rcvarc(' ', 'TEMP', '+', 'RIGI', ipg,&
                    imoy, tmoy(ipg), iret3)
        call rcvarc(' ', 'TEMP', '+', 'RIGI', ipg,&
                    3*nbcou, tsup(ipg), iret4)
        iret5 = iret5+iret2+iret3+iret4
  5 end do
!
    call jevech('PMATERC', 'L', jmate)
    call rccoma(zi(jmate), 'ELAS', 1, phenom, icodre(1))
!
! --- CAS NON TRAITES PAR CETTE ROUTINE
    if ((phenom.eq.'ELAS') .or. (phenom.eq.'ELAS_ISTR') .or. (phenom.eq.'ELAS_ORTH') .or.&
        (phenom.eq.'ELAS_COQUE')) then
        call utmess('A', 'ELEMENTS_52', sk=phenom(1:10))
        goto 9999
    endif
!
! --- CALCUL DES MATRICES DE HOOKE DE FLEXION, MEMBRANE,
! --- MEMBRANE-FLEXION, CISAILLEMENT, CISAILLEMENT INVERSE
!     ----------------------------------------------------
!
! --- BOUCLE SUR LES POINTS DE GAUSS
!     ------------------------------
    do 100 ipg = 1, npg
        do 110 icou = 1, nbcou
            do 120 igauh = 1, npgh
                icpg=nbcmp*npgh*nbcou*(ipg-1)+ nbcmp*npgh*(icou-1)+&
                nbcmp*(igauh-1)
!
                icou2 = icou
                call dxmat2(pgl, icou2, npg, ordi, epi,&
                            epais, dm, indith)
                indith=0
                if (indith .eq. -1) goto 9999
!
                if (iret5 .eq. 0) then
                    if (iret1 .eq. 1) then
                        call utmess('F', 'CALCULEL_15')
                    else
!
!  --      LES COEFFICIENTS SUIVANTS RESULTENT DE L'HYPOTHESE SELON
!  --      LAQUELLE LA TEMPERATURE EST PARABOLIQUE DANS L'EPAISSEUR.
!  --      LES COEFFICIENTS THERMOELASTIQUES PROVIENNENT DES
!  --      MATRICES QUI SONT LES RESULTATS DE LA ROUTINE DXMATL.
!          ----------------------------------------
                        coe1 = (tsup(ipg)+tinf(ipg)+4.d0*tmoy(ipg) )/ 6.d0 - tref
                        coe2 = ( tsup(ipg)-tinf(ipg))* (ordi+dble( igauh-2)*epi/2.d0 )/epais
!
                        sigma(1+icpg) = sigma(1+icpg) - ((dm(1,1)+dm( 1,2))/epi)*(coe1+coe2)
                        sigma(2+icpg) = sigma(2+icpg) - ((dm(2,1)+dm( 2,2))/epi)*(coe1+coe2)
                        sigma(4+icpg) = sigma(4+icpg) - ((dm(3,1)+dm( 3,2))/epi)*(coe1+coe2)
!
                    endif
                endif
!
120         continue
110     continue
100 end do
!
9999 continue
!
end subroutine
