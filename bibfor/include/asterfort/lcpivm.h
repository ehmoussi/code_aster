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
    subroutine lcpivm(fami, kpg, ksp, mate, compor,&
                      carcri, instam, instap, fm, df,&
                      vim, option, taup, vip, dtaudf,&
                      iret)
        character(len=*) :: fami
        integer :: kpg
        integer :: ksp
        integer :: mate
        character(len=16) :: compor
        real(kind=8) :: carcri(*)
        real(kind=8) :: instam
        real(kind=8) :: instap
        real(kind=8) :: fm(3, 3)
        real(kind=8) :: df(3, 3)
        real(kind=8) :: vim(8)
        character(len=16) :: option
        real(kind=8) :: taup(6)
        real(kind=8) :: vip(8)
        real(kind=8) :: dtaudf(6, 3, 3)
        integer :: iret
    end subroutine lcpivm
end interface
