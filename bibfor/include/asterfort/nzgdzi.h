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
    subroutine nzgdzi(fami, kpg, ksp, ndim, imat,&
                      compor, crit, instam, instap, fm,&
                      df, sigm, vim, option, sigp,&
                      vip, dsigdf, iret)
        character(len=*), intent(in) :: fami
        integer, intent(in) :: kpg
        integer, intent(in) :: ksp
        integer, intent(in) :: ndim
        integer, intent(in) :: imat
        character(len=16), intent(in) :: compor(*)
        real(kind=8), intent(in) :: crit(*)
        real(kind=8), intent(in) :: instam
        real(kind=8), intent(in) :: instap
        real(kind=8), intent(in) :: fm(3, 3)
        real(kind=8), intent(in) :: df(3, 3)
        real(kind=8), intent(in) :: sigm(*)
        real(kind=8), intent(in) :: vim(6)
        character(len=16), intent(in) :: option
        real(kind=8), intent(out) :: sigp(*)
        real(kind=8), intent(out) :: vip(6)
        real(kind=8), intent(out) :: dsigdf(6, 3, 3)
        integer, intent(out) :: iret
    end subroutine nzgdzi
end interface
