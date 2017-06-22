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

subroutine pctrii(tab, ltab)
    implicit none
    integer :: tab(ltab)
!
!-----------------------------------------------------------------------
    integer :: i, indic, ip1, itab, k, ltab
!-----------------------------------------------------------------------
    do 20 k = ltab, 2, -1
        indic = 0
        do 10 i = 1, k - 1
            ip1 = i + 1
            if (tab(i) .gt. tab(ip1)) then
                indic = 1
                itab = tab(i)
                tab(i) = tab(ip1)
                tab(ip1) = itab
            endif
10      continue
        if (indic .eq. 0) goto 30
20  end do
30  continue
end subroutine
