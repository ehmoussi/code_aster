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
    subroutine nmelnl(fami, kpg, ksp, poum, ndim,&
                      typmod, imate, compor, crit, option,&
                      eps, sig, vi, dsidep, energi)
        character(len=*) :: fami
        integer :: kpg
        integer :: ksp
        character(len=*) :: poum
        integer :: ndim
        character(len=8) :: typmod(*)
        integer :: imate
        character(len=16) :: compor(*)
        real(kind=8) :: crit(*)
        character(len=16) :: option
        real(kind=8) :: eps(6)
        real(kind=8) :: sig(6)
        real(kind=8) :: vi
        real(kind=8) :: dsidep(6, 6)
        real(kind=8) :: energi(2)
    end subroutine nmelnl
end interface
