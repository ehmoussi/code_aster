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
    subroutine matbmn(nb1, vectt, dudxnx, jdn1nx, jdn2nx,&
                      b1mnx, b2mnx)
        integer :: nb1
        real(kind=8) :: vectt(3, 3)
        real(kind=8) :: dudxnx(9)
        real(kind=8) :: jdn1nx(9, 51)
        real(kind=8) :: jdn2nx(9, 51)
        real(kind=8) :: b1mnx(3, 51)
        real(kind=8) :: b2mnx(3, 51)
    end subroutine matbmn
end interface
