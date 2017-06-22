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
    subroutine rsindi(tysca, iaobj, paobj, jordr, ival,&
                      rval, kval, cval, epsi, crit,&
                      nbordr, nbtrou, nutrou, ndim)
        character(len=4) :: tysca
        integer :: iaobj
        integer :: paobj
        integer :: jordr
        integer :: ival
        real(kind=8) :: rval
        character(len=*) :: kval
        complex(kind=8) :: cval
        real(kind=8) :: epsi
        character(len=*) :: crit
        integer :: nbordr
        integer :: nbtrou
        integer :: nutrou(*)
        integer :: ndim
    end subroutine rsindi
end interface
