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

subroutine rctres(sigm, tresca)
    implicit   none
#include "asterfort/lcqeqv.h"
#include "asterfort/rcjaco.h"
    real(kind=8) :: sigm(*), tresca
!     CALCUL DU TRESCA
! ----------------------------------------------------------------------
!     IN    T       TENSEUR CONTRAINTE
!     OUT   TRESCA  LE TRESCA
! ----------------------------------------------------------------------
    real(kind=8) :: tr(6), tu(6), nul(6)
    real(kind=8) :: equi(3)
    integer :: nt, nd
    common /tdim/  nt, nd
    data   nul     /6*0.d0/
! ----------------------------------------------------------------------
    nt = 6
    nd = 3
!
    tu(1) = 1.d0
    tu(2) = 0.d0
    tu(3) = 0.d0
    tu(4) = 1.d0
    tu(5) = 0.d0
    tu(6) = 1.d0
!
! --- MATRICE TR = (XX XY XZ YY YZ ZZ) (POUR JACOBI)
!
    tr(1) = sigm(1)
    tr(2) = sigm(4)
    tr(3) = sigm(5)
    tr(4) = sigm(2)
    tr(5) = sigm(6)
    tr(6) = sigm(3)
!
    if (lcqeqv(tr,nul) .eq. 'OUI') then
        tresca = 0.d0
    else
        call rcjaco(tr, tu, equi)
! ------ TRESCA = MAX DIFF VALEURS PRINCIPALES
        tresca = max ( abs(equi(1)-equi(2)), abs(equi(1)-equi(3)), abs(equi(2)-equi(3)) )
    endif
!
end subroutine
