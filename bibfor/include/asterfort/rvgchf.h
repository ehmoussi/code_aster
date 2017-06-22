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
    subroutine rvgchf(epsi, criter, nomsd, chpsym, acces,&
                      ival, rval, nbval, ncheff)
        real(kind=8) :: epsi
        character(len=*) :: criter
        character(len=8) :: nomsd
        character(len=16) :: chpsym
        character(len=2) :: acces
        integer :: ival(*)
        real(kind=8) :: rval(*)
        integer :: nbval
        character(len=16) :: ncheff
    end subroutine rvgchf
end interface
