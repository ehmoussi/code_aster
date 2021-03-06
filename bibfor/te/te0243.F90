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
!
subroutine te0243(option, nomte)
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
#include "asterfort/ppgan2.h"
#include "asterfort/rccoma.h"
#include "asterfort/rcdiff.h"
#include "asterfort/rcfode.h"
#include "asterfort/rcvalb.h"
#include "asterfort/runge6.h"
#include "asterfort/teattr.h"
!
    character(len=16) :: option, nomte
! ......................................................................
!    - FONCTION REALISEE:  CALCUL DES VECTEURS RESIDUS
!                          OPTION : 'RESI_RIGI_MASS'
!                          ELEMENTS 2D LUMPES
!
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
!
! THERMIQUE NON LINEAIRE
!
    integer :: icamas, nbres, nuno
    parameter (nbres=3)
    integer :: icodre(nbres)
    character(len=32) :: phenom
    real(kind=8) :: beta, lambda, theta, deltat, khi, tpg, tpsec
    real(kind=8) :: dfdx(9), dfdy(9), poids, r, r8bid, diff
    real(kind=8) :: dtpgdx, dtpgdy, hydrgm(9), hydrgp(9)
    real(kind=8) :: coorse(18), vectt(9), err
    real(kind=8) :: chal(1), tpgm
    real(kind=8) :: fluloc(2), fluglo(2), lambor(2), orig(2), p(2, 2), point(2)
    real(kind=8) :: alpha, xnorm, xu, yu
    character(len=8) :: elrefe, alias8
    integer :: ndim, nno, nnos, kp, npg, i, j, k, itemps, ifon(6)
    integer :: ipoids, ivf, idfde, igeom, imate
    integer :: icomp, itempi, iveres, jgano, ipoid2, npg2
    integer :: c(6, 9), ise, nse, nnop2, ivf2, idfde2
    integer :: isechi, isechf, ibid, jgano2
    integer :: ihydr, ihydrp, itempr
    aster_logical :: aniso, global
! ----------------------------------------------------------------------
! PARAMETER ASSOCIE AU MATERIAU CODE
!
! --- INDMAT : INDICE SAUVEGARDE POUR LE MATERIAU
!
!C      PARAMETER        ( INDMAT = 8 )
!
! DEB ------------------------------------------------------------------
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
        call elrefe_info(elrefe=elrefe, fami='NOEU', ndim=ndim, nno=nno, nnos=nnos,&
                         npg=npg2, jpoids=ipoid2, jvf=ivf2, jdfde=idfde2, jgano=jgano2)
    else
        call elrefe_info(elrefe=elrefe, fami='MASS', ndim=ndim, nno=nno, nnos=nnos,&
                         npg=npg2, jpoids=ipoid2, jvf=ivf2, jdfde=idfde2, jgano=jgano2)
    endif
!
    call elrefe_info(elrefe=elrefe, fami='RIGI', ndim=ndim, nno=nno, nnos=nnos,&
                     npg=npg, jpoids=ipoids, jvf=ivf, jdfde=idfde, jgano=jgano)
!
!====
! 1.2 PREALABLES LIES AUX RECHERCHES DE DONNEES GENERALES
!====
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PMATERC', 'L', imate)
    call jevech('PTEMPSR', 'L', itemps)
    call jevech('PTEMPEI', 'L', itempi)
    call jevech('PCOMPOR', 'L', icomp)
    call jevech('PRESIDU', 'E', iveres)
!
    deltat = zr(itemps+1)
    theta = zr(itemps+2)
    khi = zr(itemps+3)
!
!====
! 1.3 PREALABLES LIES AU SECHAGE
!====
    if ((zk16(icomp)(1:5).eq.'SECH_')) then
        if (zk16(icomp)(1:12) .eq. 'SECH_GRANGER' .or. zk16(icomp)(1:10) .eq. 'SECH_NAPPE') then
            call jevech('PTMPCHI', 'L', isechi)
            call jevech('PTMPCHF', 'L', isechf)
        else
!          POUR LES AUTRES LOIS, PAS DE CHAMP DE TEMPERATURE
!          ISECHI ET ISECHF SONT FICTIFS
            isechi = itempi
            isechf = itempi
        endif
!
!====
! 1.4 PREALABLES LIES A L ANISOTROPIE EN THERMIQUE ET RECUPERATION PARAMETRES MATERIAU
!====
    else if (zk16(icomp)(1:5) .eq. 'THER_') then
        call rccoma(zi(imate), 'THER', 1, phenom, icodre(1))
        aniso = .false.
        if (phenom(1:12) .eq. 'THER_NL_ORTH') then
            aniso = .true.
        endif
        call ntfcma(zk16(icomp), zi(imate), aniso, ifon)
!
        global = .false.
        if (aniso) then
            call jevech('PCAMASS', 'L', icamas)
            if (zr(icamas) .gt. 0.d0) then
                global = .true.
                alpha = zr(icamas+1)*r8dgrd()
                p(1,1) = cos(alpha)
                p(2,1) = sin(alpha)
                p(1,2) = -sin(alpha)
                p(2,2) = cos(alpha)
            else
                orig(1) = zr(icamas+4)
                orig(2) = zr(icamas+5)
            endif
        endif
    endif
!
!====
! 1.5 PREALABLES LIES A L'HYDRATATION
!====
    if (zk16(icomp)(1:9) .eq. 'THER_HYDR') then
        call jevech('PHYDRPM', 'L', ihydr)
        call jevech('PHYDRPP', 'E', ihydrp)
        call jevech('PTEMPER', 'L', itempr)
        call rcvalb('FPG1', 1, 1, '+', zi(imate),&
                    ' ', 'THER_HYDR', 0, ' ', [r8bid],&
                    1, 'CHALHYDR', chal, icodre(1), 1)
        do kp = 1, npg2
            k = nno*(kp-1)
            hydrgm(kp)=0.d0
            do i = 1, nno
                hydrgm(kp)= hydrgm(kp) + zr(ihydr)*zr(ivf2+k+i-1)
            end do
        end do
    endif
!====
! 1.6 PREALABLES LIES AUX ELEMENTS LUMPES
!====
!  CALCUL ISO-P2 : ELTS P2 DECOMPOSES EN SOUS-ELTS LINEAIRES
!
    call connec(nomte, nse, nnop2, c)
    do i = 1, nnop2
        vectt(i)=0.d0
    end do
!
!====
! 2. CALCULS DU TERME DE RIGIDITE DE L'OPTION
!====
! BOUCLE SUR LES SOUS-ELEMENTS
!
    do ise = 1, nse
!
        do i = 1, nno
            do j = 1, 2
                coorse(2*(i-1)+j) = zr(igeom-1+2*(c(ise,i)-1)+j)
            enddo
        enddo
!
        if (zk16(icomp)(1:5) .eq. 'THER_') then
!
!
! ----- TERME DE RIGIDITE : 2EME FAMILLE DE PTS DE GAUSS ---------
!
            do kp = 1, npg
                k = (kp-1)*nno
                call dfdm2d(nno, kp, ipoids, idfde, coorse,&
                            poids, dfdx, dfdy)
!
! -------       TRAITEMENT DE L AXISYMETRIE
! -------       EVALUATION DE LA CONDUCTIVITE LAMBDA
!
                r = 0.d0
                tpg = 0.d0
                dtpgdx = 0.d0
                dtpgdy = 0.d0
                do i = 1, nno
                    tpg = tpg + zr(itempi-1+c(ise,i)) * zr(ivf+k+i-1)
                    dtpgdx = dtpgdx + zr(itempi-1+c(ise,i)) * dfdx(i)
                    dtpgdy = dtpgdy + zr(itempi-1+c(ise,i)) * dfdy(i)
                end do
!
                if (lteatt('AXIS','OUI')) then
                    do i = 1, nno
                        r = r + coorse(2*(i-1)+1) * zr(ivf+k+i-1)
                    end do
                    poids = poids*r
                endif
!
                if (aniso) then
                    call rcfode(ifon(4), tpg, lambor(1), r8bid)
                    call rcfode(ifon(5), tpg, lambor(2), r8bid)
                else
                    call rcfode(ifon(2), tpg, lambda, r8bid)
                endif
!
! -------       CALCUL DE LA PREMIERE COMPOSANTE DU TERME ELEMENTAIRE
!
                if (.not.aniso) then
                    fluglo(1) = lambda*dtpgdx
                    fluglo(2) = lambda*dtpgdy
                else
!
! -------           TRAITEMENT DE L ANISOTROPIE
!
                    if (.not.global) then
                        point(1)=0.d0
                        point(2)=0.d0
                        do nuno = 1, nno
                            point(1)= point(1)+ zr(ivf+k+nuno-1)*coorse(2*(nuno-1)+1)
                            point(2)= point(2)+ zr(ivf+k+nuno-1)*coorse(2*(nuno-1)+2)
                        end do
                        xu = orig(1) - point(1)
                        yu = orig(2) - point(2)
                        xnorm = sqrt( xu**2 + yu**2 )
                        xu = xu / xnorm
                        yu = yu / xnorm
                        p(1,1) = xu
                        p(2,1) = yu
                        p(1,2) = -yu
                        p(2,2) = xu
                    endif
                    fluglo(1) = dtpgdx
                    fluglo(2) = dtpgdy
                    fluloc(1) = p(1,1)*dtpgdx + p(2,1)*dtpgdy
                    fluloc(2) = p(1,2)*dtpgdx + p(2,2)*dtpgdy
                    fluloc(1) = lambor(1)*fluloc(1)
                    fluloc(2) = lambor(2)*fluloc(2)
                    fluglo(1) = p(1,1)*fluloc(1) + p(1,2)*fluloc(2)
                    fluglo(2) = p(2,1)*fluloc(1) + p(2,2)*fluloc(2)
                endif
!
                do i = 1, nno
                    vectt(c(ise,i)) = vectt(c(ise,i)) +&
                                      & poids * theta *&
                                      & (fluglo(1)*dfdx(i) + fluglo(2)*dfdy(i))
                end do
            end do
!
!====
! 3. CALCULS DU TERME DE MASSE DE L'OPTION
!====
! ------- TERME DE MASSE : 3EME FAMILLE DE PTS DE GAUSS -----------
!
            do i = 1, nno
                do j = 1, 2
                    coorse(2*(i-1)+j) = zr(igeom-1+2*(c(ise,i)-1)+j)
                enddo
            enddo
!
            do kp = 1, npg2
                k = (kp-1)*nno
                call dfdm2d(nno, kp, ipoid2, idfde2, coorse,&
                            poids, dfdx, dfdy)
                r = 0.d0
                tpg = 0.d0
                do i = 1, nno
                    r = r + coorse(2*(i-1)+1) * zr(ivf2+k+i-1)
                    tpg = tpg + zr(itempi-1+c(ise,i)) * zr(ivf2+k+i-1)
                end do
!
! ---  RESOLUTION DE L EQUATION D HYDRATATION
!
                if (zk16(icomp)(1:9) .eq. 'THER_HYDR') then
                    tpgm = 0.d0
                    do i = 1, nno
                        tpgm = tpgm + zr(itempr+i-1)*zr(ivf2+k+i-1)
                    end do
                    call runge6(ifon(3), deltat, tpg, tpgm, hydrgm(kp),&
                                hydrgp(kp), err)
                endif
!
                call rcfode(ifon(1), tpg, beta, r8bid)
                if (lteatt('AXIS','OUI')) poids = poids*r
                if (zk16(icomp)(1:9) .eq. 'THER_HYDR') then
! --- THERMIQUE NON LINEAIRE AVEC HYDRATATION
                    do i = 1, nno
                        k=(kp-1)*nno
                        vectt(c(ise,i)) = vectt(c(ise,i)) +&
                                          & poids * (beta-chal(1)*hydrgp(kp)) / deltat *&
                                          & khi * zr(ivf2+k+i-1)
                    end do
                else
! --- THERMIQUE NON LINEAIRE SEULE
                    do i = 1, nno
                        vectt(c(ise,i)) = vectt(c(ise,i)) +&
                                          & poids * beta / deltat * khi * zr(ivf2+k+i-1)
                    end do
                endif
            end do
!
        else if (zk16(icomp)(1:5).eq.'SECH_') then
!
            do kp = 1, npg
                k=(kp-1)*nno
                call dfdm2d(nno, kp, ipoids, idfde, coorse,&
                            poids, dfdx, dfdy)
                r = 0.d0
                tpg = 0.d0
                dtpgdx = 0.d0
                dtpgdy = 0.d0
                tpsec = 0.d0
                do i = 1, nno
                    r = r + coorse(2*(i-1)+1) * zr(ivf+k+i-1)
                    tpg = tpg + zr(itempi-1+c(ise,i)) * zr(ivf+k+i-1)
                    dtpgdx = dtpgdx + zr(itempi-1+c(ise,i)) * dfdx(i)
                    dtpgdy = dtpgdy + zr(itempi-1+c(ise,i)) * dfdy(i)
                    tpsec = tpsec + zr(isechf-1+c(ise,i)) * zr(ivf+k+i-1)
                end do
                call rcdiff(zi(imate), zk16(icomp), tpsec, tpg, diff)
                if (lteatt('AXIS','OUI')) poids = poids*r
!
                do i = 1, nno
                    k = (kp-1)*nno
                    vectt(c(ise,i)) = vectt(c(ise,i)) +&
                                      & poids * theta * diff *&
                                      & ( dfdx(i)*dtpgdx + dfdy(i)*dtpgdy )
                end do
            end do
!
! ------- TERME DE MASSE : 3EME FAMILLE DE PTS DE GAUSS -----------
!
            do kp = 1, npg2
                k=(kp-1)*nno
                call dfdm2d(nno, kp, ipoid2, idfde2, coorse,&
                            poids, dfdx, dfdy)
                r = 0.d0
                tpg = 0.d0
                do i = 1, nno
                    r = r + coorse(2*(i-1)+1) * zr(ivf2+k+i-1)
                    tpg = tpg + zr(itempi-1+c(ise,i)) * zr(ivf2+k+i-1)
                end do
                if (lteatt('AXIS','OUI')) poids = poids*r
!
                do i = 1, nno
                    k = (kp-1)*nno
                    vectt(c(ise,i)) = vectt(&
                                      c(ise,i)) +poids * ( 1.d0/ deltat*khi*zr(ivf2+k+i-1)*tpg)
                end do
            end do
!
        endif
!
    end do
!
! MISE SOUS FORME DE VECTEUR
    do i = 1, nnop2
        zr(iveres-1+i)=vectt(i)
    end do
    if (zk16(icomp) (1:9) .eq. 'THER_HYDR') call ppgan2(jgano2, 1, 1, hydrgp, zr(ihydrp))
! FIN ------------------------------------------------------------------
end subroutine
