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

subroutine numek8(tglok8, tlock8, nbgk8, nblk8, tind)
    implicit none
#include "asterf_types.h"
!
!
    character(len=8) :: tlock8(*), tglok8(*)
    integer :: tind(*), nblk8, nbgk8
!
!***********************************************************************
!
!     TIND(I) <-- INDICE DANS LE TABLEAU TGLOK8 DE L' ELEMEMT
!                 NUMERO I DE TLOCK8
!                 (NBLK8 : DIMENSION DE TLOCK8)
!                 (NBGK8 : DIMENSION DE TGLOK8)
!
!***********************************************************************
!
    character(len=8) :: nlk8
    aster_logical :: trouve
    integer :: i, j
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    trouve = .false.
!
    i = 0
    j = 0
!
    do 10 i = 1, nblk8, 1
!
        tind (i) = 0
!
 10 end do
!
    do 100 i = 1, nblk8, 1
!
        nlk8 = tlock8(i)
!
        j = 0
!
        trouve = .false.
!
110     continue
        if ((.not. trouve) .and. (j .lt. nbgk8)) then
!
            j = j + 1
!
            if (nlk8 .eq. tglok8(j)) then
!
                trouve = .true.
!
            endif
!
            goto 110
!
        endif
!
        if (trouve) then
!
            tind(i) = j
!
        endif
!
100 end do
!
end subroutine
