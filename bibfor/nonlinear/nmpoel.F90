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

subroutine nmpoel(npg, klv, xl, nno, nc, pgl, ugl, epsthe, e, em, effm, fl, effl)
!
!
! --------------------------------------------------------------------------------------------------
!
!     POU_D_E OU POU_D_T : COMPORTEMENT ELASTIQUE
!     CALCUL DE LA MATRICE TANGENTE OPTION FULL_MECA OU RIGI_MECA_TANG
!     DES FORCES NODALES ET EFFORTS OPTION FULL_MECA OU RAPH_MECA
!
! --------------------------------------------------------------------------------------------------
!
! IN
!       npg    : nombre de point de gauss
!       klv    : matrice de rigidite elastique
!       nno    : nombre de noeuds
!       nc     : nombre de ddl
!       pgl    : matrice de passage pour poutre droite
!       ugl    : deplacement en repere global
!       itemp  : =0 : pas de temperature
!       tempm  : temperature a l'instant actuel
!       tempp  : temperature a l'instant precedent
!       alpham : coefficient de dilatation a l'instant precedent
!       alphap : coefficient de dilatation a l'instant actuel
!       e      : module d'young a l'instant actuel
!       em     : module d'young a l'instant precedent
!       num    : coefficient de poisson a l'instant precedent
!       effm   : efforts internes repre local instant precedent
! OUT
!       fl     : force nodales repere local
!       effl   : efforts internes repere local
!
! --------------------------------------------------------------------------------------------------
!
    implicit none
!
    integer :: nno, nc, npg
    real(kind=8) :: e, em, epsthe, xl
    real(kind=8) :: klv(*), pgl(*), ugl(*), effl(*), effm(*), fl(*)
!
! --------------------------------------------------------------------------------------------------
!
#include "asterfort/pmavec.h"
#include "asterfort/utpvgl.h"
#include "asterfort/vecma.h"
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: klc(12, 12), ul(12), ug(12)
    integer :: ii, jj
!
! --------------------------------------------------------------------------------------------------
!
    call vecma(klv, 78, klc, 12)
    call utpvgl(nno, nc, pgl, ugl, ul)
    call pmavec('ZERO', 12, klc, ul, fl)
!
    if (epsthe .ne. 0) then
        ug(:) = 0.d0
        if (epsthe .ne. 0.d0) then
            ug(1) = -epsthe * xl
            ug(7) = -ug(1)
            do ii = 1, 6
                do jj = 1, 6
                    fl(ii) = fl(ii) - klc(ii,jj) * ug(jj)
                    fl(ii+6) = fl(ii+6) - klc(ii+6,jj+6) * ug(jj+6)
                enddo
            enddo
        endif
    endif
!
!   Dans le calcul des efforts, il faudrait calculer comme en thermo_plasticite 3d :
!       (a+)/(a-)*(sigma-) + (a+)deps
!   c'est a dire pour les poutres :
!       F+ = (K+) (K-^(-1)) (SIGMA-) + (K+)*DELTA_U
!   Pour ne pas calculer l'inverse de la rigidite (k-) on suppose qu'elle ne varie que
!   par le module d'young. Si le coefficient de poisson est non constant la programmation
!   actuelle n'en tient pas compte, en fait nu varie peu en fonction de la temperature.
!
!   Efforts internes, force nodales repère local
    if (npg .eq. 2) then
        do ii = 1, 6
            effl(ii) = -fl(ii) + effm(ii)*e/em
            effl(ii+6) = fl(ii+6) + effm(ii+6)*e/em
            fl(ii) = -effl(ii)
            fl(ii+6) = effl(ii+6)
        enddo
    else
        do ii = 1, 6
            effl(ii) = -fl(ii) + effm(ii)*e/em
            effl(ii+12) = fl(ii+6) + effm(ii+12)*e/em
!           si npg=3, le point du milieu c'est la moyenne
            effl(ii+6) = (effl(ii) + effl(ii+12))*0.5d0
            fl(ii) = -effl(ii)
            fl(ii+6) = effl(ii+12)
        enddo
    endif
end subroutine
