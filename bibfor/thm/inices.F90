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
!
subroutine inices(maxfa, valcen, valfac)
!
implicit none
!
#include "asterc/r8maem.h"
!
integer, intent(in) :: maxfa
real(kind=8), intent(out) :: valcen(14, 6)
real(kind=8), intent(out) :: valfac(maxfa, 14, 6)
!
! --------------------------------------------------------------------------------------------------
!
! THM - Compute (finite volume)
!
! Initialization of FV quantities
!
! --------------------------------------------------------------------------------------------------
!
! In  maxfa            : maximum number of faces
! Out valfac           : values at faces
! Out valcen           : values at nodes
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i, j, k
!
! --------------------------------------------------------------------------------------------------
!
    do i = 1, 14
        do j = 1, 6
            valcen(i,j)= r8maem()
            do k = 1, maxfa
                valfac(k,i,j)= r8maem()
            end do
        end do
    end do
end subroutine
