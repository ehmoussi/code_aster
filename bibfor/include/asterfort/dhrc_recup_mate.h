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
    subroutine dhrc_recup_mate(imate, compor, a0, c0,&
                     aa_t, ga_t, ab, gb, ac,&
                     gc, aa_c, ga_c, cstseu)
        integer, intent(in) :: imate
        character(len=16), intent(in) :: compor
        real(kind=8), intent(out) :: a0(6, 6)
        real(kind=8), intent(out) :: c0(2, 2, 2)
        real(kind=8), intent(out) :: aa_t(6, 6, 2)
        real(kind=8), intent(out) :: ga_t(6, 6, 2)
        real(kind=8), intent(out) :: ab(6, 2, 2)
        real(kind=8), intent(out) :: gb(6, 2, 2)
        real(kind=8), intent(out) :: ac(2, 2, 2)
        real(kind=8), intent(out) :: gc(2, 2, 2)
        real(kind=8), intent(out) :: aa_c(6, 6, 2)
        real(kind=8), intent(out) :: ga_c(6, 6, 2)
        real(kind=8), intent(out) :: cstseu(6)
    end subroutine dhrc_recup_mate
end interface
