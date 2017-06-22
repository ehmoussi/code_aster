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

subroutine rvrthe(x, y, t1, t2, n1,&
                  n2)
    implicit none
!
    real(kind=8) :: x, y, t1, t2, n1, n2
!
!
    real(kind=8) :: r
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    r = sqrt(x*x + y*y)
!
    if (abs(r) .lt. 1.0d-6) then
!
        t1 = 1.0d0
        t2 = 0.0d0
        n2 = 1.0d0
        n1 = 0.0d0
!
    else
!
        t1 = 1.0d0/r
        t2 = t1*y
        t1 = t1*x
        n1 = -t2
        n2 = t1
!
    endif
!
end subroutine
