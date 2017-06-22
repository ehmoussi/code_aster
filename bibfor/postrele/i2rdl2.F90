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

subroutine i2rdl2(n, t, k, nom, adr)
    implicit none
#include "asterf_types.h"
    integer :: n, t(*), adr
    character(len=8) :: k, nom(*)
!
!       COPIE DE I2RDLI
!
    integer :: i, j
    aster_logical :: fini, trouve
!
    i = 1
    j = 0
    trouve = .false.
    fini = .false.
!
 10 continue
    if ((.not. fini) .and. (i .lt. adr)) then
!
        if (t(i) .lt. n) then
!
            i = i + 1
!
        else if (t(i) .eq. n) then
!
            trouve = .true.
            fini = .true.
!
        else
!
            fini = .true.
!
        endif
!
        goto 10
!
    endif
!
    if (.not. trouve) then
!
        do 20 j = adr-1, i, -1
!
            t(j+1) = t(j)
            nom(j+1) = nom(j)
!
 20     continue
!
        t(i) = n
        nom(i) = k
        adr = adr + 1
!
    endif
!
end subroutine
