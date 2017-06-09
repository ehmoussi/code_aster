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

subroutine tophys(dplmod, xgene, xphys)
    implicit none
!    Convert into the physical basis some data in generalized coordinates
!
!-----------------------------------------------------------------------
!
#include "jeveux.h"
!-----------------------------------------------------------------------
    real(kind=8), pointer, intent(in)  :: dplmod(:)
    real(kind=8), pointer, intent(in)  :: xgene(:)
    real(kind=8),          intent(out) :: xphys(:)
!-----------------------------------------------------------------------
    integer :: i, j, nbmode
!-----------------------------------------------------------------------
    nbmode = size(dplmod)/3

    do j = 1, 3
        xphys(j) = 0.d0
    end do
!
    do j = 1, 3
        do i = 1, nbmode
            xphys(j) = xphys(j) + dplmod((i-1)*3+j)*xgene(i)
        end do
    end do
end subroutine
