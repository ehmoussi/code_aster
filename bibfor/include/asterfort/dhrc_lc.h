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
    subroutine dhrc_lc(epsm, deps, vim, pgl, option,&
                      sig, vip, a0, c0,&
                      aa_t, ga_t, ab, gb, ac,&
                      gc, aa_c, ga_c, cstseu, crit,&
                      codret, dsidep, debug)
! aslint: disable=W1504
        real(kind=8), intent(in) :: epsm(6)
        real(kind=8), intent(in) :: deps(6)
        real(kind=8), intent(in) :: vim(*)
        real(kind=8), intent(in) :: pgl(3, 3)
        character(len=16), intent(in) :: option
        real(kind=8), intent(out) :: sig(8)
        real(kind=8), intent(out) :: vip(*)
        real(kind=8), intent(in) :: a0(6, 6)
        real(kind=8), intent(in) :: c0(2, 2, 2)
        real(kind=8), intent(in) :: aa_t(6, 6, 2)
        real(kind=8), intent(in) :: ga_t(6, 6, 2)
        real(kind=8), intent(in) :: ab(6, 2, 2)
        real(kind=8), intent(in) :: gb(6, 2, 2)
        real(kind=8), intent(in) :: ac(2, 2, 2)
        real(kind=8), intent(in) :: gc(2, 2, 2)
        real(kind=8), intent(in) :: aa_c(6, 6, 2)
        real(kind=8), intent(in) :: ga_c(6, 6, 2)
        real(kind=8), intent(in) :: cstseu(6)
        real(kind=8), intent(in) :: crit(*)
        integer, intent(out) :: codret
        real(kind=8), intent(out) :: dsidep(6, 6)
        aster_logical, intent(in):: debug
    end subroutine dhrc_lc
end interface 
