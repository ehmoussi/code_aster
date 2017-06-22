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
    subroutine ptma01(kanl, itype, m, ist, rho,&
                      e, a1, a2, xl, xiy1,&
                      xiy2, xiz1, xiz2, g, alfay1,&
                      alfay2, alfaz1, alfaz2, ey, ez)
        integer :: kanl
        integer :: itype
        real(kind=8) :: m(*)
        integer :: ist
        real(kind=8) :: rho
        real(kind=8) :: e
        real(kind=8) :: a1
        real(kind=8) :: a2
        real(kind=8) :: xl
        real(kind=8) :: xiy1
        real(kind=8) :: xiy2
        real(kind=8) :: xiz1
        real(kind=8) :: xiz2
        real(kind=8) :: g
        real(kind=8) :: alfay1
        real(kind=8) :: alfay2
        real(kind=8) :: alfaz1
        real(kind=8) :: alfaz2
        real(kind=8) :: ey
        real(kind=8) :: ez
    end subroutine ptma01
end interface
