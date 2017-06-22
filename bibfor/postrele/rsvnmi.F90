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

subroutine rsvnmi(t, vm)
    implicit none
!
!
    real(kind=8) :: t(*), vm
!
    real(kind=8) :: inv
    integer :: i
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    inv = 0.0d0
    vm = 0.0d0
!
    do 10, i = 1, 3, 1
!
    inv = inv + t(i)*t(i)
!
    10 end do
!
    do 20, i = 4, 6, 1
!
    inv = inv + 2.0d0*t(i)*t(i)
!
    20 end do
!
    vm = sqrt(3.0d0*inv*0.5d0)
!
end subroutine
