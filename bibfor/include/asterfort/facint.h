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
    subroutine facint(nbpas, dim, longh, vec1, vec2,&
                      long, s, r, d, u,&
                      v, w)
        integer :: long
        integer :: longh
        integer :: dim
        integer :: nbpas
        real(kind=8) :: vec1(long)
        real(kind=8) :: vec2(longh)
        complex(kind=8) :: s(dim, dim)
        complex(kind=8) :: r(dim, dim)
        real(kind=8) :: d(dim)
        complex(kind=8) :: u(*)
        real(kind=8) :: v(*)
        complex(kind=8) :: w(*)
    end subroutine facint
end interface
