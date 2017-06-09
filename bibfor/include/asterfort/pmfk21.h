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
    subroutine pmfk21(sk, casect, a, xl, &
                  xjx, xig, g, alfay,&
                  alfaz, ey, ez)
        integer :: id
        real(kind=8) :: sk(*)
        real(kind=8) :: casect(6)
        real(kind=8) :: a
        real(kind=8) :: xl
        real(kind=8) :: xjx
        real(kind=8) :: xig
        real(kind=8) :: g
        real(kind=8) :: alfay
        real(kind=8) :: alfaz
        real(kind=8) :: ey
        real(kind=8) :: ez
    end subroutine pmfk21
end interface
