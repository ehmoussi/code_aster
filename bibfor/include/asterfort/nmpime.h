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
    subroutine nmpime(fami, kpg, ksp, imate, option,&
                      xlong0, a, xlongm, dlong0, ncstpm,&
                      cstpm, vim, effnom, vip, effnop,&
                      klv, fono)
        integer :: ncstpm
        character(len=*) :: fami
        integer :: kpg
        integer :: ksp
        integer :: imate
        character(len=*) :: option
        real(kind=8) :: xlong0
        real(kind=8) :: a
        real(kind=8) :: xlongm
        real(kind=8) :: dlong0
        real(kind=8) :: cstpm(ncstpm)
        real(kind=8) :: vim(8)
        real(kind=8) :: effnom
        real(kind=8) :: vip(8)
        real(kind=8) :: effnop
        real(kind=8) :: klv(21)
        real(kind=8) :: fono(6)
    end subroutine nmpime
end interface
