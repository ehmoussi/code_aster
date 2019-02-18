! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
    subroutine calc_moment(e0, kappa, e_b, f_t, f_c, c,&
                           h, e_a, s_a, y_a, f_ta, cas, eff, mom)
        real(kind=8) :: e0
        real(kind=8) :: kappa
        real(kind=8) :: e_b
        real(kind=8) :: f_t
        real(kind=8) :: f_c
        real(kind=8) :: c
        real(kind=8) :: h
        real(kind=8) :: e_a
        real(kind=8) :: s_a
        real(kind=8) :: y_a
        real(kind=8) :: f_ta
        integer :: cas
        real(kind=8) :: eff
        real(kind=8) :: mom
    end subroutine calc_moment
end interface
