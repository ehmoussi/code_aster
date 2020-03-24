! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
!
function lxl_find(chaine, char1)
!
implicit none
!
integer :: lxl_find
character(len=*), intent(in) :: chaine
character(len=1), intent(in) :: char1

    integer :: i, lg
    lxl_find = 0
    lg = len( chaine )
    do i = 1, lg
        if (chaine(i:i) .eq. char1) then
            lxl_find = i
            goto 999
        endif
    end do
    lxl_find = 0
999 continue
end function
