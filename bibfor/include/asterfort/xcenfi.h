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
    subroutine xcenfi(elrefp, ndim, ndime, nno, geom, lsn,&
                      pinref, pmiref, cenref, cenfi,&
                      nn, exit, jonc, num)
        character(len=8) :: elrefp
        integer :: ndim
        integer :: ndime
        integer :: nno
        real(kind=8) :: geom(*)
        real(kind=8) :: lsn(*)
        real(kind=8) :: pinref(*)
        real(kind=8) :: pmiref(*)
        real(kind=8) :: cenref(ndime)
        real(kind=8) :: cenfi(ndim)
        integer :: nn(4)
        integer :: exit(2)
        aster_logical :: jonc
        integer, intent(in), optional :: num(8)
    end subroutine xcenfi
end interface 
