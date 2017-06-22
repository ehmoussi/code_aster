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

subroutine impfoi(unit, length, vali, string)
!
implicit none
!
#include "asterfort/assert.h"
!
!
    integer, intent(in) :: unit
    integer, intent(in) :: length
    integer, intent(in) :: vali
    character(len=*), intent(out) :: string
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Print management
!
! Create string to print integer in logical unit
!
! --------------------------------------------------------------------------------------------------
!
! In  unit             : logical unit
! In  length           : length of integer
! In  vali             : integer to print
! Out string           : string created
!
! --------------------------------------------------------------------------------------------------
!
    character(len=4) :: for4
    character(len=5) :: for5
    character(len=1) :: for1
    integer :: form_length
!
! --------------------------------------------------------------------------------------------------
!
    if (length .le. 9) then
        form_length = 4
        for4(1:2) = '(I'
        write(for1,'(I1)') length
        for4(3:3) = for1
        for4(4:4) = ')'
    else if (length.le.19) then
        form_length = 5
        for5(1:2) = '(I'
        for5(3:3) = '1'
        write(for1,'(I1)') length-10
        for5(4:4) = for1
        for5(5:5) = ')'
    else
        ASSERT(.false.)
    endif
!
    if (unit .ne. 0) then
        if (form_length .eq. 4) then
            write(unit,for4) vali
        else if (form_length.eq.5) then
            write(unit,for5) vali
        else
            ASSERT(.false.)
        endif
    else
        if (form_length .eq. 4) then
            write(string,for4) vali
        else if (form_length.eq.5) then
            write(string,for5) vali
        else
            ASSERT(.false.)
        endif
    endif
!
end subroutine
