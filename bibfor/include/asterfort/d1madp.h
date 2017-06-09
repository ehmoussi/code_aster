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
    subroutine d1madp(fami, mater, instan, poum, kpg,&
                      ksp, repere, d1)
        character(len=*) :: fami
        integer :: mater
        real(kind=8) :: instan
        character(len=*) :: poum
        integer :: kpg
        integer :: ksp
        real(kind=8) :: repere(7)
        real(kind=8) :: d1(4, *)
    end subroutine d1madp
end interface
