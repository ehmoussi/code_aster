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

subroutine jjanal(condlu, nval, nvalo, lval, cval)
! person_in_charge: j-pierre.lefebvre at edf.fr
    implicit none
#include "asterfort/utmess.h"
    character(len=*) :: condlu, cval(*)
    integer :: nval, nvalo, lval(*)
!
    integer :: long, i, j, nbsc
!
    do 20 i = 1, nval
        cval (i) = ' '
        lval (i) = 0
20  end do
    long = len(condlu)
    if (long .eq. 0 .and. nvalo .gt. 0) then
        call utmess('F', 'JEVEUX1_31')
    endif
    nbsc = 0
    i = 1
!
 1  continue
    if (i .gt. long) then
        if (nbsc .lt. nvalo) then
            call utmess('F', 'JEVEUX1_31')
        else
            goto 100
        endif
    endif
    if (condlu(i:i) .eq. ' ') then
        i = i + 1
        goto 1
    endif
    j = i + 1
 2  continue
    if (j .gt. long) goto 3
    if (condlu(j:j) .ne. ' ') then
        j = j + 1
        goto 2
    endif
!
 3  continue
    nbsc = nbsc + 1
    cval( nbsc ) = condlu(i:j-1)
    lval( nbsc ) = j - i
    if (nbsc .lt. nval .and. j .le. long) then
        i = j + 1
        goto 1
    else if (nbsc .lt. nvalo .and. j.eq. long+1) then
        call utmess('F', 'JEVEUX1_31')
    endif
100  continue
    do 10 i = j, long
        if (condlu(i:i) .ne. ' ') then
            call utmess('F', 'JEVEUX1_32')
        endif
10  end do
!
end subroutine
