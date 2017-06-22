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
    subroutine xmifis(ndim, ndime, elrefp, geom, lsn, &
                  n, ip1, ip2, pinref, miref, mifis, &
                  pintt, exit, jonc, u, v)
        integer :: ndime
        integer :: ndim
        integer :: n(3)
        character(len=8) :: elrefp
        real(kind=8) :: geom(*)
        real(kind=8) :: lsn(*)
        integer :: ip1
        integer :: ip2
        real(kind=8) :: pinref(*)
        real(kind=8) :: miref(ndime)
        real(kind=8) :: mifis(ndim)
        real(kind=8) :: pintt(*)
        aster_logical :: jonc
        integer :: exit(2)
        real(kind=8), intent(in), optional :: u(ndime)
        real(kind=8), intent(in), optional :: v(ndime)
    end subroutine xmifis
end interface
