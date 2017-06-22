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

subroutine impfok(mesg, length, unit)
!
implicit none
!
#include "asterfort/assert.h"
!
!
    character(len=*), intent(in) :: mesg
    integer, intent(in) :: length
    integer, intent(in) :: unit
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Print management
!
! Create string to print text in logical unit
!
! --------------------------------------------------------------------------------------------------
!
! In  mesg             : message to write
! In  length           : length of message
! In  unit             : logical unit
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: zlig  = 512
    character(len=6) :: forma
!
! --------------------------------------------------------------------------------------------------
!
    if (length .le. 0) then
        forma = '(A)'
    else if (length .gt. zlig) then
        ASSERT(.false.)
    else
        write(forma,10) length
    endif
    if (unit .le. 0) then
        ASSERT(.false.)
    else
        write(unit,forma) mesg(1:length)
    endif
!
10  format ('(A',i3,')')
!
end subroutine
