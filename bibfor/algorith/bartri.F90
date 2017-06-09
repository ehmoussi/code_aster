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

subroutine bartri(i1, i2, coor, poin)
    implicit none
#include "asterfort/barso1.h"
#include "asterfort/utmess.h"
    integer :: i1, i2, poin(*)
    real(kind=8) :: coor(*)
!     BARSOUM : TRAITEMENT DES MAILLES "TRIA6" ET "TRIA7"
!-----------------------------------------------------------------------
!
    integer :: i, n1, n2, n3
!     ------------------------------------------------------------------
!
!     ------------------------------------------------------------------
!                       TRAITEMENT DES "POI1"
!     ------------------------------------------------------------------
    if (i1 .eq. 1 .and. i2 .eq. 0) then
        do 110 i = 1, 2
            if (i .eq. 1) then
                n1 = 1
                n2 = 2
                n3 = 4
            else
                n1 = 1
                n2 = 3
                n3 = 6
            endif
            call barso1(n1, n2, n3, coor, poin)
110      continue
    else if (i1.eq.2 .and. i2.eq.0) then
        do 120 i = 1, 2
            if (i .eq. 1) then
                n1 = 2
                n2 = 1
                n3 = 4
            else
                n1 = 2
                n2 = 3
                n3 = 5
            endif
            call barso1(n1, n2, n3, coor, poin)
120      continue
    else if (i1.eq.3 .and. i2.eq.0) then
        do 130 i = 1, 2
            if (i .eq. 1) then
                n1 = 3
                n2 = 1
                n3 = 6
            else
                n1 = 3
                n2 = 2
                n3 = 5
            endif
            call barso1(n1, n2, n3, coor, poin)
130      continue
!
!     ------------------------------------------------------------------
!                       TRAITEMENT DES "SEG3"
!     ------------------------------------------------------------------
    else if (i1+i2 .eq. 3) then
        do 210 i = 1, 2
            if (i .eq. 1) then
                n1 = 2
                n2 = 3
                n3 = 5
            else
                n1 = 1
                n2 = 3
                n3 = 6
            endif
            call barso1(n1, n2, n3, coor, poin)
210      continue
!
    else if (i1+i2 .eq. 5) then
        do 220 i = 1, 2
            if (i .eq. 1) then
                n1 = 3
                n2 = 1
                n3 = 6
            else
                n1 = 2
                n2 = 1
                n3 = 4
            endif
            call barso1(n1, n2, n3, coor, poin)
220      continue
!
    else if (i1+i2 .eq. 4) then
        do 230 i = 1, 2
            if (i .eq. 1) then
                n1 = 3
                n2 = 2
                n3 = 5
            else
                n1 = 1
                n2 = 2
                n3 = 4
            endif
            call barso1(n1, n2, n3, coor, poin)
230      continue
!
    else
        call utmess('F', 'ALGORITH_36', sk='TRIA')
!
    endif
!
end subroutine
