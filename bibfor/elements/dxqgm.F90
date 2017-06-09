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

subroutine dxqgm(shpr1, shpr2, gm)
    implicit  none
#include "asterf_types.h"
    real(kind=8) :: shpr1(3,4), shpr2(3,4), gm(3, 4)
!     MATRICE GM(3,4) MEMBRANE AU POINT QSI ETA POUR ELEMENTS DKQ ET DSQ
!     ------------------------------------------------------------------
!     ADDED LOCAL VARIABLES :
    integer :: j
!     ------------------------------------------------------------------
!
!
    do j = 1, 4
     gm(1,j) = shpr1(1,j)
     gm(2,j) = shpr2(2,j)
     gm(3,j) = shpr1(2,j) + shpr2(1,j)
    end do


!
end subroutine
