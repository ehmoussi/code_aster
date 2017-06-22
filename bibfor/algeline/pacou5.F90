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

subroutine pacou5(r, qt, n, u, v)
    implicit none
!
! ARGUMENTS
! ---------
#include "jeveux.h"
#include "asterfort/pacou6.h"
    integer :: n
    real(kind=8) :: r(n, *), qt(n, *), u(*), v(*)
    integer :: i, j, k
! ---------------------------------------------------------------------
!
    do 11 k = n, 1, -1
        if (abs(u(k)) .gt. 1.0d-30) goto 1
11  end do
    k = 1
!
 1  continue
!
    do 12 i = k-1, 1, -1
!
        call pacou6(r, qt, n, i, u(i),&
                    -u(i+1))
!
        if (abs(u(i)) .le. 1.0d-30) then
            u(i) = abs(u(i+1))
!
        else if (abs(u(i)) .gt. abs(u(i+1))) then
            u(i) = abs(u(i)) * sqrt(1.0d0+(u(i+1)/u(i))**2)
!
        else
            u(i) = abs(u(i+1)) * sqrt(1.0d0+(u(i)/u(i+1))**2)
!
        endif
12  end do
!
    do 13 j = 1, n
        r(1,j) = r(1,j) + u(1)*v(j)
13  end do
!
    do 14 i = 1, k-1
!
        call pacou6(r, qt, n, i, r(i, i),&
                    -r(i+1, i))
14  end do
!
end subroutine
