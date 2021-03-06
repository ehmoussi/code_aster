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

subroutine barhex(i1, i2, coor, poin)
    implicit none
#include "asterfort/barso1.h"
#include "asterfort/utmess.h"
    integer :: i1, i2, poin(*)
    real(kind=8) :: coor(*)
!     BARSOUM : TRAITEMENT DES MAILLES "HEXA20" ET "HEXA27"
!-----------------------------------------------------------------------
!
    integer :: i, n1, n2, n3
!     ------------------------------------------------------------------
!
!     ------------------------------------------------------------------
!                       TRAITEMENT DES "POI1"
!     ------------------------------------------------------------------
    if (i1 .eq. 1 .and. i2 .eq. 0) then
        do 110 i = 1, 3
            if (i .eq. 1) then
                n1 = 1
                n2 = 2
                n3 = 9
            else if (i .eq. 2) then
                n1 = 1
                n2 = 4
                n3 = 12
            else if (i .eq. 3) then
                n1 = 1
                n2 = 5
                n3 = 13
            endif
            call barso1(n1, n2, n3, coor, poin)
110      continue
    else if (i1.eq.2 .and. i2.eq.0) then
        do 120 i = 1, 3
            if (i .eq. 1) then
                n1 = 2
                n2 = 1
                n3 = 9
            else if (i .eq. 2) then
                n1 = 2
                n2 = 3
                n3 = 10
            else if (i .eq. 3) then
                n1 = 2
                n2 = 6
                n3 = 14
            endif
            call barso1(n1, n2, n3, coor, poin)
120      continue
    else if (i1.eq.3 .and. i2.eq.0) then
        do 130 i = 1, 3
            if (i .eq. 1) then
                n1 = 3
                n2 = 2
                n3 = 10
            else if (i .eq. 2) then
                n1 = 3
                n2 = 4
                n3 = 11
            else if (i .eq. 3) then
                n1 = 3
                n2 = 7
                n3 = 15
            endif
            call barso1(n1, n2, n3, coor, poin)
130      continue
    else if (i1.eq.4 .and. i2.eq.0) then
        do 140 i = 1, 3
            if (i .eq. 1) then
                n1 = 4
                n2 = 1
                n3 = 12
            else if (i .eq. 2) then
                n1 = 4
                n2 = 3
                n3 = 11
            else if (i .eq. 3) then
                n1 = 4
                n2 = 8
                n3 = 16
            endif
            call barso1(n1, n2, n3, coor, poin)
140      continue
    else if (i1.eq.5 .and. i2.eq.0) then
        do 150 i = 1, 3
            if (i .eq. 1) then
                n1 = 5
                n2 = 1
                n3 = 13
            else if (i .eq. 2) then
                n1 = 5
                n2 = 6
                n3 = 17
            else if (i .eq. 3) then
                n1 = 5
                n2 = 8
                n3 = 20
            endif
            call barso1(n1, n2, n3, coor, poin)
150      continue
    else if (i1.eq.6 .and. i2.eq.0) then
        do 160 i = 1, 3
            if (i .eq. 1) then
                n1 = 6
                n2 = 2
                n3 = 14
            else if (i .eq. 2) then
                n1 = 6
                n2 = 5
                n3 = 17
            else if (i .eq. 3) then
                n1 = 6
                n2 = 7
                n3 = 18
            endif
            call barso1(n1, n2, n3, coor, poin)
160      continue
    else if (i1.eq.7 .and. i2.eq.0) then
        do 170 i = 1, 3
            if (i .eq. 1) then
                n1 = 7
                n2 = 3
                n3 = 15
            else if (i .eq. 2) then
                n1 = 7
                n2 = 6
                n3 = 18
            else if (i .eq. 3) then
                n1 = 7
                n2 = 8
                n3 = 19
            endif
            call barso1(n1, n2, n3, coor, poin)
170      continue
    else if (i1.eq.8 .and. i2.eq.0) then
        do 180 i = 1, 3
            if (i .eq. 1) then
                n1 = 8
                n2 = 4
                n3 = 16
            else if (i .eq. 2) then
                n1 = 8
                n2 = 5
                n3 = 20
            else if (i .eq. 3) then
                n1 = 8
                n2 = 7
                n3 = 19
            endif
            call barso1(n1, n2, n3, coor, poin)
180      continue
!
!     ------------------------------------------------------------------
!                       TRAITEMENT DES "SEG3"
!     ------------------------------------------------------------------
    else if (i1+i2 .eq. 3) then
        do 210 i = 1, 4
            if (i .eq. 1) then
                n1 = 2
                n2 = 6
                n3 = 14
            else if (i .eq. 2) then
                n1 = 2
                n2 = 3
                n3 = 10
            else if (i .eq. 3) then
                n1 = 1
                n2 = 5
                n3 = 13
            else if (i .eq. 4) then
                n1 = 1
                n2 = 4
                n3 = 12
            endif
            call barso1(n1, n2, n3, coor, poin)
210      continue
!
    else if ((i1+i2.eq.5) .and. (i1.eq.2 .or. i2.eq.2)) then
        do 220 i = 1, 4
            if (i .eq. 1) then
                n1 = 3
                n2 = 7
                n3 = 15
            else if (i .eq. 2) then
                n1 = 3
                n2 = 4
                n3 = 11
            else if (i .eq. 3) then
                n1 = 2
                n2 = 6
                n3 = 14
            else if (i .eq. 4) then
                n1 = 2
                n2 = 1
                n3 = 9
            endif
            call barso1(n1, n2, n3, coor, poin)
220      continue
!
    else if (i1+i2 .eq. 7) then
        do 230 i = 1, 4
            if (i .eq. 1) then
                n1 = 4
                n2 = 8
                n3 = 16
            else if (i .eq. 2) then
                n1 = 4
                n2 = 1
                n3 = 12
            else if (i .eq. 3) then
                n1 = 3
                n2 = 7
                n3 = 15
            else if (i .eq. 4) then
                n1 = 3
                n2 = 2
                n3 = 10
            endif
            call barso1(n1, n2, n3, coor, poin)
230      continue
!
    else if ((i1+i2.eq.5) .and. (i1.eq.4 .or. i2.eq.4)) then
        do 240 i = 1, 4
            if (i .eq. 1) then
                n1 = 4
                n2 = 8
                n3 = 16
            else if (i .eq. 2) then
                n1 = 4
                n2 = 3
                n3 = 11
            else if (i .eq. 3) then
                n1 = 1
                n2 = 5
                n3 = 13
            else if (i .eq. 4) then
                n1 = 1
                n2 = 2
                n3 = 9
            endif
            call barso1(n1, n2, n3, coor, poin)
240      continue
!
    else if (i1+i2 .eq. 6) then
        do 250 i = 1, 4
            if (i .eq. 1) then
                n1 = 5
                n2 = 8
                n3 = 20
            else if (i .eq. 2) then
                n1 = 5
                n2 = 6
                n3 = 17
            else if (i .eq. 3) then
                n1 = 1
                n2 = 4
                n3 = 12
            else if (i .eq. 4) then
                n1 = 1
                n2 = 2
                n3 = 9
            endif
            call barso1(n1, n2, n3, coor, poin)
250      continue
!
    else if (i1+i2 .eq. 8) then
        do 260 i = 1, 4
            if (i .eq. 1) then
                n1 = 6
                n2 = 7
                n3 = 18
            else if (i .eq. 2) then
                n1 = 6
                n2 = 5
                n3 = 17
            else if (i .eq. 3) then
                n1 = 2
                n2 = 3
                n3 = 10
            else if (i .eq. 4) then
                n1 = 2
                n2 = 1
                n3 = 9
            endif
            call barso1(n1, n2, n3, coor, poin)
260      continue
!
    else if (i1+i2 .eq. 10) then
        do 270 i = 1, 4
            if (i .eq. 1) then
                n1 = 7
                n2 = 8
                n3 = 19
            else if (i .eq. 2) then
                n1 = 7
                n2 = 6
                n3 = 18
            else if (i .eq. 3) then
                n1 = 3
                n2 = 4
                n3 = 11
            else if (i .eq. 4) then
                n1 = 3
                n2 = 2
                n3 = 10
            endif
            call barso1(n1, n2, n3, coor, poin)
270      continue
!
    else if (i1+i2 .eq. 12) then
        do 280 i = 1, 4
            if (i .eq. 1) then
                n1 = 8
                n2 = 7
                n3 = 19
            else if (i .eq. 2) then
                n1 = 8
                n2 = 5
                n3 = 20
            else if (i .eq. 3) then
                n1 = 4
                n2 = 3
                n3 = 11
            else if (i .eq. 4) then
                n1 = 4
                n2 = 1
                n3 = 12
            endif
            call barso1(n1, n2, n3, coor, poin)
280      continue
!
    else if (i1+i2 .eq. 11) then
        do 290 i = 1, 4
            if (i .eq. 1) then
                n1 = 6
                n2 = 7
                n3 = 18
            else if (i .eq. 2) then
                n1 = 6
                n2 = 2
                n3 = 14
            else if (i .eq. 3) then
                n1 = 5
                n2 = 8
                n3 = 20
            else if (i .eq. 4) then
                n1 = 5
                n2 = 1
                n3 = 13
            endif
            call barso1(n1, n2, n3, coor, poin)
290      continue
!
    else if ((i1+i2.eq.13) .and. (i1.eq.7 .or. i2.eq.7)) then
        do 292 i = 1, 4
            if (i .eq. 1) then
                n1 = 7
                n2 = 8
                n3 = 19
            else if (i .eq. 2) then
                n1 = 7
                n2 = 3
                n3 = 15
            else if (i .eq. 3) then
                n1 = 6
                n2 = 5
                n3 = 17
            else if (i .eq. 4) then
                n1 = 6
                n2 = 2
                n3 = 14
            endif
            call barso1(n1, n2, n3, coor, poin)
292      continue
!
    else if (i1+i2 .eq. 15) then
        do 294 i = 1, 4
            if (i .eq. 1) then
                n1 = 8
                n2 = 5
                n3 = 20
            else if (i .eq. 2) then
                n1 = 8
                n2 = 4
                n3 = 16
            else if (i .eq. 3) then
                n1 = 7
                n2 = 6
                n3 = 18
            else if (i .eq. 4) then
                n1 = 7
                n2 = 3
                n3 = 15
            endif
            call barso1(n1, n2, n3, coor, poin)
294      continue
!
    else if ((i1+i2.eq.13) .and. (i1.eq.8 .or. i2.eq.8)) then
        do 296 i = 1, 4
            if (i .eq. 1) then
                n1 = 8
                n2 = 7
                n3 = 19
            else if (i .eq. 2) then
                n1 = 8
                n2 = 4
                n3 = 16
            else if (i .eq. 3) then
                n1 = 5
                n2 = 6
                n3 = 17
            else if (i .eq. 4) then
                n1 = 5
                n2 = 1
                n3 = 13
            endif
            call barso1(n1, n2, n3, coor, poin)
296      continue
!
    else
        call utmess('F', 'ALGORITH_36', sk='HEXA')
!
    endif
!
end subroutine
