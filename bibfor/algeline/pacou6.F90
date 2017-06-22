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

subroutine pacou6(r, qt, n, i, a,&
                  b)
    implicit none
!
! ARGUMENTS
! ---------
#include "jeveux.h"
    integer :: n, i
    real(kind=8) :: a, b, r(n, *), qt(n, *)
! ---------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: j
    real(kind=8) :: c, fact, s, w, y
!-----------------------------------------------------------------------
    if (abs(a) .le. 1.0d-30) then
        c = 0.0d0
        s = sign(1.0d0,b)
!
    else if (abs(a) .gt. abs(b)) then
        fact = b/a
        c = sign ( 1.0d0/sqrt(1.0d0+fact*fact), a )
        s = fact*c
!
    else
        fact = a/b
        s = sign ( 1.0d0/sqrt(1.0d0+fact*fact), b )
        c = fact*s
!
    endif
!
    do 11 j = 1, n
        y = r(i,j)
        w = r(i+1,j)
        r(i,j) = c*y - s*w
        r(i+1,j) = s*y + c*w
11  end do
!
    do 12 j = 1, n
        y = qt(i,j)
        w = qt(i+1,j)
        qt(i,j) = c*y - s*w
        qt(i+1,j) = s*y + c*w
12  end do
!
end subroutine
