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

subroutine impfor(unit, length, prec, valr, string)
!
implicit none
!
#include "asterc/r8vide.h"
#include "asterfort/assert.h"
!
!
    integer, intent(in) :: unit
    integer, intent(in) :: length
    integer, intent(in) :: prec
    real(kind=8), intent(in) :: valr
    character(len=*), intent(out) :: string
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Print management
!
! Create string to print real in logical unit
!
! --------------------------------------------------------------------------------------------------
!
! In  unit             : logical unit
! In  length           : length of real
! In  prec             : precision of real
! In  valr             : real to print
! Out string           : string created
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: for8
    character(len=9) :: for9
    character(len=1) :: for1
    integer :: form_length, prec_local
!
! --------------------------------------------------------------------------------------------------
!
    prec_local = prec
    if ((prec .lt. 1) .or. (prec .gt. 9)) then
        prec_local = 5
    endif
!
    if (valr .eq. r8vide()) then
        if (unit .ne. 0) then
            write(unit,'(A)') ' '
        else
            write(string,'(A)') ' '
        endif
        goto 99
    endif
!
    if (length .le. 9) then
        form_length = 8
        for8(1:4) = '(1PE'
        write(for1,'(I1)') length
        for8(5:5) = for1
        for8(6:6) = '.'
        write(for1,'(I1)') prec_local
        for8(7:7) = for1
        for8(8:8) = ')'
    else if (length .le. 19) then
        form_length = 9
        for9(1:4) = '(1PE'
        for9(5:5) = '1'
        write(for1,'(I1)') length-10
        for9(6:6) = for1
        for9(7:7) = '.'
        write(for1,'(I1)') prec_local
        for9(8:8) = for1
        for9(9:9) = ')'
    else
        ASSERT(.false.)
    endif
!
    if (unit .ne. 0) then
        if (form_length .eq. 8) then
            write(unit,for8) valr
        else if (form_length.eq.9) then
            write(unit,for9) valr
        else
            ASSERT(.false.)
        endif
    else
        if (form_length .eq. 8) then
            write(string,for8) valr
        else if (form_length.eq.9) then
            write(string,for9) valr
        else
            ASSERT(.false.)
        endif
    endif
!
99  continue
!
end subroutine
