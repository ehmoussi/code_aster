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
    subroutine lcedga(fami, kpg, ksp, ndim, imat,&
                      crit, typmod, instam, instap,&
                      deps2, sigm2, vim, option, sigp,&
                      vip, dsidep, iret)
        character(len=*), intent(in) :: fami
        integer, intent(in) :: kpg
        integer, intent(in) :: ksp
        integer, intent(in) :: ndim
        integer, intent(in) :: imat
        real(kind=8), intent(in) :: crit(*)
        character(len=8), intent(in) :: typmod(2)
        real(kind=8), intent(in) :: instam
        real(kind=8), intent(in) :: instap
        real(kind=8), intent(in) :: deps2(*)
        real(kind=8), intent(in) :: sigm2(*)
        real(kind=8), intent(in) :: vim(5)
        character(len=16), intent(in) :: option
        real(kind=8), intent(out) :: sigp(*)
        real(kind=8), intent(out) :: vip(5)
        real(kind=8), intent(out) :: dsidep(6, 6)
        integer, intent(out) :: iret
    end subroutine lcedga
end interface
