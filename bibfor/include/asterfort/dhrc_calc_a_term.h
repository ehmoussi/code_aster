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
    subroutine dhrc_calc_a_term(i, j, sup_s, inf_s,a0, aa_t, ga_t, aa_c, ga_c, vint, &
                                a, ap1, ap2, as1, as2, rvp, sup_d, inf_d)
        integer, intent(in) :: i
        integer, intent(in) :: j
        integer, intent(in) :: sup_s
        integer, intent(in) :: inf_s
        integer, optional, intent(in) :: sup_d
        integer, optional, intent(in) :: inf_d
        real(kind=8), optional, intent(in) :: rvp
        real(kind=8), intent(in) :: vint(*)
        real(kind=8), intent(in) :: a0(6, 6)
        real(kind=8), intent(in) :: aa_t(6, 6, 2)
        real(kind=8), intent(in) :: ga_t(6, 6, 2)
        real(kind=8), intent(in) :: aa_c(6, 6, 2)
        real(kind=8), intent(in) :: ga_c(6, 6, 2)
        real(kind=8), intent(out) :: a
        real(kind=8), intent(out) :: ap1
        real(kind=8), intent(out) :: ap2
        real(kind=8), intent(out) :: as1
        real(kind=8), intent(out) :: as2
    end subroutine dhrc_calc_a_term
end interface 
