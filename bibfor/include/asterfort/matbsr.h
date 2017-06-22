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
    subroutine matbsr(nb1, vectt, dudxrc, intsr, jdn1rc,&
                      jdn2rc, b1src, b2src)
        integer :: nb1
        real(kind=8) :: vectt(3, 3)
        real(kind=8) :: dudxrc(9)
        integer :: intsr
        real(kind=8) :: jdn1rc(9, 51)
        real(kind=8) :: jdn2rc(9, 51)
        real(kind=8) :: b1src(2, 51, 4)
        real(kind=8) :: b2src(2, 51, 4)
    end subroutine matbsr
end interface
