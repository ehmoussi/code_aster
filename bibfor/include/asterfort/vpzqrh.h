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
    subroutine vpzqrh(h, neq, ih, k, l,&
                      wr, wi, z, iz, mxiter,&
                      ier, nitqr)
        integer :: iz
        integer :: ih
        integer :: neq
        real(kind=8) :: h(ih, neq)
        integer :: k
        integer :: l
        real(kind=8) :: wr(neq)
        real(kind=8) :: wi(neq)
        real(kind=8) :: z(iz, neq)
        integer :: mxiter
        integer :: ier
        integer :: nitqr
    end subroutine vpzqrh
end interface
