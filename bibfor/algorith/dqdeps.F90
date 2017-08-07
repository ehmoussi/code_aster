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
subroutine dqdeps(mdal, temp, dqeps)
!
implicit none
!
real(kind=8), intent(in) :: temp
real(kind=8) :: mdal(6), dqeps(6)
! ======================================================================
!
! --- CALCUL DE LA DERIVEE DE LA CHALEUR PAR RAPPORT A LA DEFORMATION --
! --- VOLUMIQUE --------------------------------------------------------
! ======================================================================
    integer :: i
    real(kind=8), parameter :: rac2 = sqrt(2.d0)
    do i = 1, 3
        dqeps(i) = mdal(i)*temp
    end do
    do i = 4, 6
        dqeps(i) = mdal(i)*temp*rac2
    end do
!
end subroutine
