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

subroutine dxefgt(pgl, sigt)
    implicit none
#include "jeveux.h"
#include "asterfort/dxmath.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/r8inir.h"
#include "asterfort/rccoma.h"
#include "asterfort/rcvarc.h"
#include "asterfort/utmess.h"
    real(kind=8) :: pgl(3, 3), sigt(1)
! --- EFFORTS GENERALISES N, M, V D'ORIGINE THERMIQUE AUX POINTS
! --- D'INTEGRATION POUR LES ELEMENTS COQUES A FACETTES PLANES :
! --- DST, DKT, DSQ, DKQ, Q4G DUS :
! ---  .A UN CHAMP DE TEMPERATURES SUR LE PLAN MOYEN DONNANT
! ---        DES EFFORTS DE MEMBRANE
! ---  .A UN GRADIENT DE TEMPERATURES DANS L'EPAISSEUR DE LA COQUE
!     ------------------------------------------------------------------
!     IN  PGL(3,3)     : MATRICE DE PASSAGE DU REPERE GLOBAL AU REPERE
!                        LOCAL
!     OUT SIGT(1)      : EFFORTS  GENERALISES D'ORIGINE THERMIQUE
!                        AUX POINTS D'INTEGRATION
    integer :: ndim, nno, nnos, npg, ipoids, icoopg, ivf, idfdx, idfd2, jgano
    integer :: multic, ipg, nbcou, npgh, somire
    real(kind=8) :: df(3, 3), dm(3, 3), dmf(3, 3)
    real(kind=8) :: tmoypg, tsuppg, tinfpg
    real(kind=8) :: t2iu(4), t2ui(4), t1ve(9)
    integer :: icodre(56)
    character(len=4) :: fami
    character(len=10) :: phenom
!     ------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: igau, indith, iret1, iret2, iret3, iret4, jcara
    integer :: jcou, jmate
    real(kind=8) :: coe1, coe2, epais, tref
!-----------------------------------------------------------------------
    fami = 'RIGI'
    call elrefe_info(fami=fami,ndim=ndim,nno=nno,nnos=nnos,npg=npg,jpoids=ipoids,&
                    jcoopg=icoopg,jvf=ivf,jdfde=idfdx,jdfd2=idfd2,jgano=jgano)
!
    call r8inir(32, 0.d0, sigt, 1)
!
! --- POUR L'INSTANT PAS DE PRISE EN COMPTE DES CONTRAINTES
! --- THERMIQUES POUR LES MATERIAUX MULTICOUCHES
!     ------------------------------------------
    call jevech('PMATERC', 'L', jmate)
    call rccoma(zi(jmate), 'ELAS', 1, phenom, icodre(1))
!
! --- RECUPERATION DE LA TEMPERATURE DE REFERENCE ET
! --- DE L'EPAISSEUR DE LA COQUE
!     --------------------------
!
    call jevech('PCACOQU', 'L', jcara)
    epais = zr(jcara)
!
    call rcvarc(' ', 'TEMP', 'REF', fami, 1, 1, tref, iret1)
!
!
! --- CALCUL DES COEFFICIENTS THERMOELASTIQUES DE FLEXION,
! --- MEMBRANE, MEMBRANE-FLEXION
!     ----------------------------------------------------
!
    call dxmath('RIGI', epais, df, dm, dmf, pgl, multic, indith, t2iu, t2ui, t1ve, npg)
    if (indith .ne. -1) then
!
        call jevech('PNBSP_I', 'L', jcou)
        nbcou=zi(jcou)
        ipg=(3*nbcou+1)/2
        npgh=3
!
! --- BOUCLE SUR LES POINTS D'INTEGRATION
!     -----------------------------------
        do igau = 1, npg
!
!  --      TEMPERATURES SUR LES FEUILLETS MOYEN, SUPERIEUR ET INFERIEUR
!  --      AU POINT D'INTEGRATION COURANT
!          ------------------------------
            call rcvarc(' ', 'TEMP', '+', fami, igau, ipg, tmoypg, iret2)
            call rcvarc(' ', 'TEMP', '+', fami, igau, 1, tinfpg, iret3)
            call rcvarc(' ', 'TEMP', '+', fami, igau, npgh*nbcou, tsuppg, iret4)
            somire = iret2+iret3+iret4
            if (somire .eq. 0) then
                if (iret1 .eq. 1) then
                    call utmess('F', 'COMPOR5_43')
                else
!
!  --      LES COEFFICIENTS SUIVANTS RESULTENT DE L'HYPOTHESE SELON
!  --      LAQUELLE LA TEMPERATURE EST PARABOLIQUE DANS L'EPAISSEUR.
!  --      ON NE PREJUGE EN RIEN DE LA NATURE DU MATERIAU.
!  --      CETTE INFORMATION EST CONTENUE DANS LES MATRICES QUI
!  --      SONT LES RESULTATS DE LA ROUTINE DXMATH.
!          ----------------------------------------
                    coe1 = (tsuppg+tinfpg+4.d0*tmoypg)/6.d0 - tref
                    coe2 = (tsuppg-tinfpg)/epais
!
                    sigt(1+8* (igau-1)) = coe1* ( dm(1,1)+dm(1,2)) + coe2* (dmf(1,1)+dmf(1,2) )
                    sigt(2+8* (igau-1)) = coe1* ( dm(2,1)+dm(2,2)) + coe2* (dmf(2,1)+dmf(2,2) )
                    sigt(3+8* (igau-1)) = coe1* ( dm(3,1)+dm(3,2)) + coe2* (dmf(3,1)+dmf(3,2) )
                    sigt(4+8* (igau-1)) = coe2* ( df(1,1)+df(1,2)) + coe1* (dmf(1,1)+dmf(1,2) )
                    sigt(5+8* (igau-1)) = coe2* ( df(2,1)+df(2,2)) + coe1* (dmf(2,1)+dmf(2,2) )
                    sigt(6+8* (igau-1)) = coe2* ( df(3,1)+df(3,2)) + coe1* (dmf(3,1)+dmf(3,2) )
                endif
            endif
        end do
    endif
end subroutine
