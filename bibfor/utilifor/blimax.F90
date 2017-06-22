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

function blimax(n, dx, incx)
! REMPLACE LA FONCTION INTMAX SUR LES MACHINES OU ELLE N'EST PAS
! DISPONIBLE DANS LES LIBRAIRIES SYSTEME
!
!
    implicit none
    integer :: blimax
    integer :: n, dx(1), incx
    integer :: i, ix, imax, max
!
    blimax = 0
    if (n .le. 0) goto 9999
    if (incx .ne. 1) then
!
!        CODE FOR UNEQUAL INCREMENTS OR EQUAL INCREMENTS
!          NOT EQUAL TO 1
!
        ix = 1
        if(incx.lt.0)ix = (-n+1)*incx + 1
        imax = ix
        max = dx(ix)
        do 10 i = 1, n
            if (dx(ix) .gt. max) then
                imax = ix
                max = dx(ix)
            endif
            ix = ix + incx
10      continue
        blimax = imax
    else
!
!        CODE FOR INCREMENT EQUAL TO 1
!
        imax = 1
        max = dx(1)
        do 20 i = 1, n
            if (dx(i) .gt. max) then
                imax = i
                max = dx(i)
            endif
20      continue
        blimax = imax
    endif
9999  continue
end function
