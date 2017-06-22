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
    subroutine ptka01(sk, e, a, xl, xiy,&
                      xiz, xjx, g, alfay, alfaz,&
                      ey, ez, ist)
        real(kind=8) :: sk(*)
        real(kind=8) :: e
        real(kind=8) :: a
        real(kind=8) :: xl
        real(kind=8) :: xiy
        real(kind=8) :: xiz
        real(kind=8) :: xjx
        real(kind=8) :: g
        real(kind=8) :: alfay
        real(kind=8) :: alfaz
        real(kind=8) :: ey
        real(kind=8) :: ez
        integer :: ist
    end subroutine ptka01
end interface
