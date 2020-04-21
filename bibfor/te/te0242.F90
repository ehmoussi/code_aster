! --------------------------------------------------------------------
! Copyright (C) 2019 Christophe Durand - www.code-aster.org
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

subroutine te0242(option, nomte)
! aslint: disable=C1513
    implicit none
#include "jeveux.h"
#include "asterc/r8dgrd.h"
#include "asterfort/connec.h"
#include "asterfort/dfdm2d.h"
#include "asterfort/elref1.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
#include "asterfort/ntfcma.h"
#include "asterfort/rcdiff.h"
#include "asterfort/rcfode.h"
#include "asterfort/teattr.h"
#include "asterfort/rccoma.h"
#include "asterfort/utpvgl.h"
#include "asterfort/utpvlg.h"
#include "asterfort/utrcyl.h"
!
    character(len=16) :: option, nomte
! ----------------------------------------------------------------------
!    - FONCTION REALISEE:  CALCUL DES MATRICES ELEMENTAIRES
!                          OPTION : 'MTAN_RIGI_MASS'
!                          ELEMENTS 2D LUMPES
!
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
!
! THERMIQUE NON LINEAIRE
!
    integer :: icamas, nbres, nuno
    parameter ( nbres=3 )
    integer :: icodre(nbres)
    character(len=8) :: elrefe, alias8
    character(len=32) :: phenom
    real(kind=8) :: lambda, r8bid, rhocp, deltat
    real(kind=8) :: dfdx(9), dfdy(9), poids, r, theta, khi, tpgi
    real(kind=8) :: mt(9, 9), coorse(18), diff, tpsec, tpg
    real(kind=8) :: fluloc(2), fluglo(2), lambor(2), orig(2), p(2, 2), point(2)
    real(kind=8) :: alpha, xnorm, xu, yu
    integer :: ndim, nno, nnos, kp, npg, i, j, ij, k, itemps, ifon(6)
    integer :: ipoids, ivf, idfde, igeom, imate
    integer :: icomp, itempi, imattt, jgano, ipoid2, npg2
    integer :: c(6, 9), ise, nse, nnop2, ivf2, idfde2
    integer :: isechf, isechi, ibid
    aster_logical :: aniso, global
!
!====
! 1.1 PREALABLES: RECUPERATION ADRESSES FONCTIONS DE FORMES...
!====
    call elref1(elrefe)
!
    if (lteatt('LUMPE','OUI')) then
        call teattr('S', 'ALIAS8', alias8, ibid)
        if (alias8(6:8) .eq. 'QU9') elrefe='QU4'
        if (alias8(6:8) .eq. 'TR6') elrefe='TR3'
        call elrefe_info( elrefe=elrefe, fami='NOEU',&
                          ndim=ndim    , nno=nno       , nnos=nnos,&
                          npg=npg2     , jpoids=ipoid2 , jvf=ivf2 ,&
                          jdfde=idfde2 , jgano=jgano )
    else
        call elrefe_info( elrefe=elrefe, fami='MASS',&
                          ndim=ndim    , nno=nno      , nnos=nnos,&
                          npg=npg2     , jpoids=ipoid2, jvf=ivf2 ,&
                          jdfde=idfde2 , jgano=jgano )
    endif
!
    call elrefe_info( elrefe=elrefe , fami='RIGI' ,&
                      ndim=ndim     , nno=nno       , nnos=nnos,&
                      npg=npg       , jpoids=ipoids , jvf=ivf  ,&
                      jdfde=idfde   , jgano=jgano )
!
!====
! 1.2 PREALABLES LIES AUX RECHERCHES DE DONNEES GENERALES
!====
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PMATERC', 'L', imate)
    call jevech('PTEMPSR', 'L', itemps)
    call jevech('PTEMPEI', 'L', itempi)
    call jevech('PCOMPOR', 'L', icomp)
    call jevech('PMATTTR', 'E', imattt)
!
    deltat= zr(itemps+1)
    theta = zr(itemps+2)
    khi   = zr(itemps+3)
!====
! 1.3 PREALABLES LIES AU SECHAGE
!====
    if ((zk16(icomp)(1:5).eq.'SECH_')) then
        if (zk16(icomp)(1:12) .eq. 'SECH_GRANGER' .or. zk16(icomp)(1:10) .eq. 'SECH_NAPPE') then
            call jevech('PTMPCHI', 'L', isechi)
            call jevech('PTMPCHF', 'L', isechf)
        else
!            POUR LES AUTRES LOIS, PAS DE CHAMP DE TEMPERATURE
!            ISECHI ET ISECHF SONT FICTIFS
            isechi = itempi
            isechf = itempi
        endif
!====
! 1.4 PREALABLES LIES A L ANISOTROPIE EN THERMIQUE ET RECUPERATION PARAMETRES MATERIAU
!====
    else if (zk16(icomp)(1:5) .eq. 'THER_') then
        call rccoma(zi(imate), 'THER', 1, phenom, icodre(1))
        aniso = .false.
        if (phenom(1:12) .eq. 'THER_NL_ORTH') then
            aniso  = .true.
        endif
        call ntfcma(zk16(icomp), zi(imate), aniso, ifon)
!
        global = .false.
        if (aniso) then
            call jevech('PCAMASS', 'L', icamas)
            if (zr(icamas) .gt. 0.d0) then
                global = .true.
                alpha  = zr(icamas+1)*r8dgrd()
                p(1,1) =  cos(alpha)
                p(2,1) =  sin(alpha)
                p(1,2) = -sin(alpha)
                p(2,2) =  cos(alpha)
            else
                orig(1) = zr(icamas+4)
                orig(2) = zr(icamas+5)
            endif
        endif
    endif
!====
! 1.5 PREALABLES LIES AUX ELEMENTS LUMPES
!====
!  CALCUL ISO-P2 : ELTS P2 DECOMPOSES EN SOUS-ELTS LINEAIRES
!
    call connec(nomte, nse, nnop2, c)
!
    do 11 i = 1, nnop2
        do 12 j = 1, nnop2
            mt(i,j)=0.d0
 12     continue
 11 continue
!
!====
! 2. CALCULS DU TERME DE L'OPTION
!====
! ----- 2EME FAMILLE DE PTS DE GAUSS/BOUCLE SUR LES SOUS-ELEMENTS
!
    do 200 ise = 1, nse
!
        do 50 i = 1, nno
            do 51 j = 1, 2
                coorse(2*(i-1)+j) = zr(igeom-1+2*(c(ise,i)-1)+j)
51          continue
50      continue
!
        if (zk16(icomp)(1:5) .eq. 'THER_') then
!
! ------- CALCUL DU PREMIER TERME
! ------- TERME DE RIGIDITE : 2EME FAMILLE DE PTS DE GAUSS ---------
!
            do 101 kp = 1, npg
                k=(kp-1)*nno
                call dfdm2d(nno, kp, ipoids, idfde, coorse,&
                            poids, dfdx, dfdy)
!
! -------       TRAITEMENT DE L AXISYMETRTIE
! -------       EVALUATION DE LA CONDUCTIVITE LAMBDA
!
                r    = 0.d0
                tpgi = 0.d0
                do 102 i = 1, nno
                    r    = r    + coorse(2*(i-1)+1)     * zr(ivf+k+i-1)
                    tpgi = tpgi + zr(itempi-1+c(ise,i)) * zr(ivf+k+i-1)
102              continue
                if (lteatt('AXIS','OUI')) poids = poids*r
!
                if (aniso) then
                    call rcfode(ifon(4), tpgi, lambor(1), r8bid)
                    call rcfode(ifon(5), tpgi, lambor(2), r8bid)
                else
                    call rcfode(ifon(2), tpgi, lambda, r8bid)
                endif
!
! -------       TRAITEMENT DE L ANISOTROPIE
!
                if (.not.global .and. aniso) then
                    point(1) = 0.d0
                    point(2) = 0.d0
                    do 104 nuno = 1, nno
                        point(1)= point(1) + zr(ivf+k+nuno-1)*coorse(2*(nuno-1)+1)
                        point(2)= point(2) + zr(ivf+k+nuno-1)*coorse(2*(nuno-1)+2)
104                 continue
!
                    xu = orig(1) - point(1)
                    yu = orig(2) - point(2)
                    xnorm = sqrt( xu**2 + yu**2 )
                    xu = xu / xnorm
                    yu = yu / xnorm
                    p(1,1) =  xu
                    p(2,1) =  yu
                    p(1,2) = -yu
                    p(2,2) =  xu
                endif
!
! -------       CALCUL DE LA PREMIERE COMPOSANTE DU TERME ELEMENTAIRE
!
                ij = imattt - 1
                do i = 1, nno
                    if (.not.aniso) then
                        fluglo(1) = lambda*dfdx(i)
                        fluglo(2) = lambda*dfdy(i)
                    else
                        fluloc(1) = p(1,1)*dfdx(i) + p(2,1)*dfdy(i)
                        fluloc(2) = p(1,2)*dfdx(i) + p(2,2)*dfdy(i)
                        fluloc(1) = lambor(1)*fluloc(1)
                        fluloc(2) = lambor(2)*fluloc(2)
                        fluglo(1) = p(1,1)*fluloc(1) + p(1,2)*fluloc(2)
                        fluglo(2) = p(2,1)*fluloc(1) + p(2,2)*fluloc(2)
                    endif
                    do j = 1, nno
                        ij = ij + 1
                        mt(c(ise,i),c(ise,j)) = mt( c(ise,i) , c(ise,j) )+&
                                                & poids * theta *&
                                                & ( fluglo(1)*dfdx(j) + fluglo(2)*dfdy(j) )
                    enddo
                enddo
101          continue
!
! ------- CALCUL DU DEUXIEME TERME
! ------- TERME DE MASSE : 3EME FAMILLE DE PTS DE GAUSS -----------
!
            do i = 1, nno
                do j = 1, 2
                    coorse(2*(i-1)+j) = zr(igeom-1+2*(c(ise,i)-1)+j)
                enddo
             enddo
!
            do 401 kp = 1, npg2
                k=(kp-1)*nno
                call dfdm2d(nno, kp, ipoid2, idfde2, coorse,&
                            poids, dfdx, dfdy)
                r = 0.d0
                tpgi = 0.d0
                do 402 i = 1, nno
                    r    = r    + coorse(2*(i-1)+1)     * zr(ivf2+k+i-1)
                    tpgi = tpgi + zr(itempi-1+c(ise,i)) * zr(ivf2+k+i-1)
402              continue
                if (lteatt('AXIS','OUI')) poids = poids*r
                call rcfode(ifon(1), tpgi, r8bid, rhocp)
!
                ij = imattt - 1
                do i = 1, nno
                    do j = 1, nno
                        ij = ij + 1
                        mt(c(ise,i),c(ise,j)) = mt( c(ise,i), c(ise,j)) +&
                                                & poids * khi * rhocp *&
                                                & zr(ivf2+k+i-1) * zr(ivf2+k+j-1) /deltat
                    enddo
                enddo
401          continue
!
! --- SECHAGE
!
        else if (zk16(icomp)(1:5).eq.'SECH_') then
!
! ----- TERME DE RIGIDITE : 2EME FAMILLE DE PTS DE GAUSS ---------
!
            do 203 kp = 1, npg
                k=(kp-1)*nno
                call dfdm2d(nno, kp, ipoids, idfde, coorse,&
                            poids, dfdx, dfdy)
                r     = 0.d0
                tpg   = 0.d0
                tpsec = 0.d0
                do 201 i = 1, nno
                    r     = r     + coorse(2*(i-1)+1)     *zr(ivf+k+i-1)
                    tpg   = tpg   + zr(itempi-1+c(ise,i)) *zr(ivf+k+i-1)
                    tpsec = tpsec + zr(isechf-1+c(ise,i)) *zr(ivf+k+i-1)
201              continue
                if (lteatt('AXIS','OUI')) poids = poids*r
                call rcdiff(zi(imate), zk16(icomp), tpsec, tpg, diff)
!
                ij = imattt - 1
                do i = 1, nno
!
                    do j = 1, nno
                        ij = ij + 1
                        mt(c(ise,i),c(ise,j)) = mt( c(ise,i), c(ise,j)) + poids *&
                                                &( diff * theta *&
                                                &  ( dfdx(i)*dfdx(j) + dfdy(i)*dfdy(j) ) )
                    enddo
                enddo
203          continue
!
! ------- TERME DE MASSE : 3EME FAMILLE DE PTS DE GAUSS -----------
!
            do i = 1, nno
                do j = 1, 2
                    coorse(2*(i-1)+j) = zr(igeom-1+2*(c(ise,i)-1)+j)
                enddo
            enddo
!
            do 304 kp = 1, npg2
                k=(kp-1)*nno
                call dfdm2d(nno, kp, ipoid2, idfde2, coorse,&
                            poids, dfdx, dfdy)
                r = 0.d0
                do i = 1, nno
                    r = r + coorse(2*(i-1)+1) *zr(ivf2+k+i-1)
                enddo
                if (lteatt('AXIS','OUI')) poids = poids*r
!
                ij = imattt - 1
                do i = 1, nno
!
                    do j = 1, nno
                        ij = ij + 1
                        mt(c(ise,i),c(ise,j)) = mt( c(ise,i), c(ise,j)) + poids*&
                                                &( khi * zr(ivf2+k+i-1) * zr(ivf2+k+j-1) / deltat )
                    enddo
                enddo
304          continue
        endif
!
! FIN DE LA BOUCLE SUR LES SOUS-ELEMENTS
!
200  end do
!
! MISE SOUS FORME DE VECTEUR
    ij = imattt-1
    do i = 1, nnop2
        do j = 1, i
            ij = ij +1
            zr(ij)=mt(i,j)
        enddo
    enddo
! FIN ------------------------------------------------------------------
end subroutine
