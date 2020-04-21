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
subroutine te0244(option, nomte)
!    - FONCTION REALISEE:  CALCUL DES VECTEURS ELEMENTAIRES
!                          OPTION : 'CHAR_THER_EVOLNI'
!                          ELEMENTS 2D ISOPARAMETRIQUES
!
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
!
! THERMIQUE NON LINEAIRE LUMPE SANS HYDRATATION, NI SECHAGE
!----------------------------------------------------------------------
! CORPS DU PROGRAMME
    implicit none
!
! PARAMETRES D'APPEL
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/r8dgrd.h"
#include "asterfort/connec.h"
#include "asterfort/dfdm2d.h"
#include "asterfort/elref1.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
#include "asterfort/ntfcma.h"
#include "asterfort/rccoma.h"
#include "asterfort/rcdiff.h"
#include "asterfort/rcfode.h"
#include "asterfort/rcvalb.h"
#include "asterfort/teattr.h"
!
    character(len=16) :: nomte, option
!
    integer :: icamas, nbres, nuno
    parameter (nbres=3)
    integer :: icodre(nbres)
    character(len=8) :: elrefe, alias8
    character(len=32) :: phenom
    real(kind=8) :: beta, dbeta, lambda, dfdx(9), dfdy(9), poids, r, tpg
    real(kind=8) :: theta, deltat, dtpgdx, dtpgdy, coorse(18), vectt(9)
    real(kind=8) :: vecti(9), diff, tpsec, chal(1), hydrpg(9)
    real(kind=8) :: fluloc(2), fluglo(2), lambor(2), orig(2), p(2, 2), point(2)
    real(kind=8) :: alpha, xnorm, xu, yu, r8bid
    integer :: ndim, nno, nnos, kp, npg, i, j, k, itemps, jgano, ipoids, ivf
    integer :: idfde, igeom, imate, icomp, ifon(6), itemp, ivectt, ivecti
    integer :: c(6, 9), ise, nse, nnop2, npg2, ipoid2, ivf2, idfde2, isechf
    integer :: isechi, ibid, ihydr
    aster_logical :: laxi, lhyd
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
        call elrefe_info(elrefe=elrefe, fami='NOEU', ndim=ndim, nno=nno, nnos=nnos,&
                         npg=npg2, jpoids=ipoid2, jvf=ivf2, jdfde=idfde2, jgano=jgano)
    else
        call elrefe_info(elrefe=elrefe, fami='MASS', ndim=ndim, nno=nno, nnos=nnos,&
                         npg=npg2, jpoids=ipoid2, jvf=ivf2, jdfde=idfde2, jgano=jgano)
    endif
!
    call elrefe_info(elrefe=elrefe, fami='RIGI', ndim=ndim, nno=nno, nnos=nnos,&
                     npg=npg, jpoids=ipoids, jvf=ivf, jdfde=idfde, jgano=jgano)
!
    if (lteatt('AXIS','OUI')) then
        laxi = .true.
    else
        laxi = .false.
    endif
!
!====
! 1.2 PREALABLES LIES AUX RECHERCHES DE DONNEES GENERALES
!====
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PMATERC', 'L', imate)
    call jevech('PTEMPSR', 'L', itemps)
    call jevech('PTEMPER', 'L', itemp)
    call jevech('PCOMPOR', 'L', icomp)
    call jevech('PVECTTR', 'E', ivectt)
    call jevech('PVECTTI', 'E', ivecti)
!
    deltat = zr(itemps+1)
    theta = zr(itemps+2)
!
!====
! 1.3 PREALABLES LIES AU SECHAGE
!====
    if (zk16(icomp)(1:5) .eq. 'SECH_') then
        if (zk16(icomp)(1:12) .eq. 'SECH_GRANGER' .or. zk16(icomp)(1:10) .eq. 'SECH_NAPPE') then
            call jevech('PTMPCHI', 'L', isechi)
            call jevech('PTMPCHF', 'L', isechf)
        else
!          POUR LES AUTRES LOIS, PAS DE CHAMP DE TEMPERATURE
!          ISECHI ET ISECHF SONT FICTIFS
            isechi = itemp
            isechf = itemp
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
!====
! 1.5 PREALABLES LIES A L'HYDRATATION
!====
    if (zk16(icomp)(1:9) .eq. 'THER_HYDR') then
        lhyd = .true.
        call jevech('PHYDRPM', 'L', ihydr)
        call rcvalb('FPG1', 1, 1, '+', zi(imate),&
                    ' ', 'THER_HYDR', 0, ' ', [0.d0],&
                    1, 'CHALHYDR', chal, icodre(1), 1)
        do kp = 1, npg2
            k = nno*(kp-1)
            hydrpg(kp)=0.d0
            do i = 1, nno
                hydrpg(kp) = hydrpg(kp) + zr(ihydr)*zr(ivf2+k+i-1)
            end do
        end do
    else
        lhyd = .false.
    endif
!====
! 1.6 PREALABLES LIES AUX ELEMENTS LUMPES
!====
!  CALCUL ISO-P2 : ELTS P2 DECOMPOSES EN SOUS-ELTS LINEAIRES
!
    call connec(nomte, nse, nnop2, c)
    do i = 1, nnop2
        vectt(i) = 0.d0
        vecti(i) = 0.d0
    end do
!
!====
! 2. CALCULS DU TERME DE RIGIDITE DE L'OPTION
!====
! ----- 2EME FAMILLE DE PTS DE GAUSS/BOUCLE SUR LES SOUS-ELEMENTS
!
    do ise = 1, nse
!
        if (zk16(icomp)(1:5) .eq. 'THER_') then
!
            do i = 1, nno
                do j = 1, 2
                    coorse(2*(i-1)+j) = zr(igeom-1+2*(c(ise,i)-1)+j)
                end do
            end do
!
            do kp = 1, npg
                k=(kp-1)*nno
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
                    tpg = tpg + zr(itemp-1+c(ise,i)) * zr(ivf+k+i-1)
                    dtpgdx = dtpgdx + zr(itemp-1+c(ise,i)) * dfdx(i)
                    dtpgdy = dtpgdy + zr(itemp-1+c(ise,i)) * dfdy(i)
                end do
                if (laxi) then
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
! CALCUL STD A 2 OUTPUTS (LE DEUXIEME NE SERT QUE POUR LA PREDICTION)
!
                do i = 1, nno
                    vectt(c(ise,i)) = vectt(c(ise,i))-&
                                      & poids * (1.0d0-theta) *&
                                      & (fluglo(1)*dfdx(i) + fluglo(2)*dfdy(i))
                    vecti(c(ise,i)) = vecti(c(ise,i))-&
                                      & poids * (1.0d0-theta) *&
                                      & (fluglo(1)*dfdx(i) + fluglo(2)*dfdy(i))
                end do
! FIN DE LA BOUCLE SUR LES PT DE GAUSS
            end do
!
!====
! 3. CALCULS DU TERME DE MASSE DE L'OPTION
!====
! ------- 3EME FAMILLE DE PTS DE GAUSS -----------
!
            do i = 1, nno
                do j = 1, 2
                    coorse(2*(i-1)+j) = zr(igeom-1+2*(c(ise,i)-1)+j)
                end do
            end do
!
            do kp = 1, npg2
                k=(kp-1)*nno
                call dfdm2d(nno, kp, ipoids, idfde2, coorse,&
                            poids, dfdx, dfdy)
                r = 0.d0
                tpg = 0.d0
                do i = 1, nno
! CALCUL DE T-
                    tpg = tpg + zr(itemp-1+c(ise,i)) * zr(ivf2+k+i-1)
                end do
                if (laxi) then
                    do i = 1, nno
! CALCUL DE R POUR JACOBIEN
                        r = r + coorse(2*(i-1)+1) * zr(ivf2+k+i-1)
                    end do
                    poids = poids*r
                endif
!
! CALCUL DES CARACTERISTIQUES MATERIAUX
! ON LES EVALUE AVEC TPG=T-
                call rcfode(ifon(1), tpg, beta, dbeta)
                if (lhyd) then
! THER_HYDR
                    do i = 1, nno
                        vectt(c(ise,i)) = vectt(c(ise,i)) + poids*&
                                          &((beta     -chal(1)*hydrpg(kp))*&
                                                               &zr(ivf2+k+i-1)/deltat)
                        vecti(c(ise,i)) = vecti(c(ise,i)) + poids*&
                                          &((dbeta*tpg-chal(1)*hydrpg(kp))*&
                                                               &zr(ivf2+k+i-1)/deltat)
                    end do
                else
! THER_NL
! CALCUL A 2 OUTPUTS (LE DEUXIEME NE SERT QUE POUR LA PREDICTION)
!
                    do i = 1, nno
                        vectt(c(ise,i)) = vectt(c(ise,i)) + poids * beta        /&
                                                          & deltat * zr(ivf2+k+i-1)
                        vecti(c(ise,i)) = vecti(c(ise,i)) + poids * dbeta * tpg /&
                                                          & deltat * zr(ivf2+k+i-1)
                    end do
! FIN BOUCLE LHYD
                endif
! FIN DE BOUCLE SUR LES PT DE GAUSS
            end do
!
        else if (zk16(icomp)(1:5).eq.'SECH_') then
!
!        CALCULS DU TERME DE RIGIDITE DE L'OPTION
!
            do i = 1, nno
                do j = 1, 2
                    coorse(2*(i-1)+j) = zr(igeom-1+2*(c(ise,i)-1)+j)
                end do
            end do
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
                    r = r + coorse(2*(i-1)+1) *zr(ivf+k+i-1)
                    tpg = tpg + zr(itemp -1+c(ise,i)) *zr(ivf+k+i-1)
                    dtpgdx = dtpgdx + zr(itemp -1+c(ise,i)) *dfdx(i)
                    dtpgdy = dtpgdy + zr(itemp -1+c(ise,i)) *dfdy(i)
                    tpsec = tpsec + zr(isechi-1+c(ise,i)) *zr(ivf+k+i-1)
                end do
                call rcdiff(zi(imate), zk16(icomp), tpsec, tpg, diff)
                if (laxi) poids = poids*r
!
                do i = 1, nno
                    vectt(c(ise,i)) = vectt(c(ise,i)) +&
                                      & poids * ( -(1.0d0-theta)*diff*&
                                                  &( dfdx(i)*dtpgdx + dfdy(i)*dtpgdy ) )
                    vecti(c(ise,i)) = vectt(c(ise,i))
                end do
            end do
!
!  CALCULS DU TERME DE MASSE DE L'OPTION
!
            do i = 1, nno
                do j = 1, 2
                    coorse(2*(i-1)+j) = zr(igeom-1+2*(c(ise,i)-1)+j)
                end do
            end do
!
            do kp = 1, npg2
                k=(kp-1)*nno
                call dfdm2d(nno, kp, ipoid2, idfde2, coorse,&
                            poids, dfdx, dfdy)
                r = 0.d0
                tpg = 0.d0
                do i = 1, nno
                    r = r + coorse(2*(i-1)+1) *zr(ivf2+k+i-1)
                    tpg = tpg + zr(itemp-1+c(ise,i)) *zr(ivf2+k+i-1)
                end do
                if (laxi) poids = poids*r
!
                do i = 1, nno
                    vectt(c(ise,i)) = vectt(c(ise,i)) + poids *( tpg / deltat * zr(ivf2+k+i-1) )
                    vecti(c(ise,i)) = vectt(c(ise,i))
                end do
            end do
!
        endif
! FIN DE BOUCLE SUR LES SOUS-ELEMENTS
    end do
!
! MISE SOUS FORME DE VECTEUR
    do i = 1, nnop2
        zr(ivectt-1+i)=vectt(i)
        zr(ivecti-1+i)=vecti(i)
    end do
! FIN ------------------------------------------------------------------
end subroutine
