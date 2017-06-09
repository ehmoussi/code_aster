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
!
interface
    subroutine dracs2(a0, b0, c0, d0, e0,&
                      f0, nbroot, x, y)
        real(kind=8), intent(in) :: a0(2)
        real(kind=8), intent(in):: b0(2)
        real(kind=8), intent(in) :: c0(2)
        real(kind=8), intent(in) :: d0(2)
        real(kind=8), intent(in) :: e0(2)
        real(kind=8), intent(in) :: f0(2)
        integer, intent(out) :: nbroot
        real(kind=8), intent(out) :: x(4)
        real(kind=8), intent(out) :: y(4)
    end subroutine dracs2
end interface
