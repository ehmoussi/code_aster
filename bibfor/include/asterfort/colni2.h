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
    subroutine colni2(col1, col2, n, d1, d2,&
                      coef1, t1, t2, eps, ier)
        integer :: n
        real(kind=8) :: col1(n)
        real(kind=8) :: col2(n)
        real(kind=8) :: d1
        real(kind=8) :: d2
        real(kind=8) :: coef1
        real(kind=8) :: t1(n)
        real(kind=8) :: t2(n)
        real(kind=8) :: eps
        integer :: ier
    end subroutine colni2
end interface
