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
    subroutine dinttc(coord1, coord2, xo1o2, yo1o2, zo1o2,&
                      do1o2, r, norm, nint, nhop,&
                      npir, coord, nbi)
        real(kind=8) :: coord1(3)
        real(kind=8) :: coord2(3)
        real(kind=8) :: xo1o2
        real(kind=8) :: yo1o2
        real(kind=8) :: zo1o2
        real(kind=8) :: do1o2
        real(kind=8) :: r
        integer :: norm(2, 4)
        integer :: nint
        integer :: nhop
        integer :: npir
        real(kind=8) :: coord(3, 12)
        integer :: nbi
    end subroutine dinttc
end interface
