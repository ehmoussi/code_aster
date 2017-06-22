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
    subroutine nmasym(fami, kpg, ksp, icodma, option,&
                      xlong0, a, tmoins, tplus, dlong0,&
                      effnom, vim, effnop, vip, klv,&
                      fono)
        character(len=*) :: fami
        integer :: kpg
        integer :: ksp
        integer :: icodma
        character(len=*) :: option
        real(kind=8) :: xlong0
        real(kind=8) :: a
        real(kind=8) :: tmoins
        real(kind=8) :: tplus
        real(kind=8) :: dlong0
        real(kind=8) :: effnom
        real(kind=8) :: vim(4)
        real(kind=8) :: effnop
        real(kind=8) :: vip(4)
        real(kind=8) :: klv(21)
        real(kind=8) :: fono(6)
    end subroutine nmasym
end interface
