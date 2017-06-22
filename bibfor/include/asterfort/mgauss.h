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
    subroutine mgauss(cara, a, b, dim, nordre,&
                      nb, det, iret)
        integer :: nb
        integer :: dim
        character(len=*) :: cara
        real(kind=8) :: a(dim, dim)
        real(kind=8) :: b(dim, nb)
        integer :: nordre
        real(kind=8) :: det
        integer :: iret
    end subroutine mgauss
end interface
