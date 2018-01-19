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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine nonlinDSColumnWriteValue(length      , output_string_,&
                                    output_unit_,&
                                    value_r_    ,&
                                    value_i_    ,&
                                    value_k_    ,&
                                    time_   )
!
implicit none
!
#include "asterf_types.h"
#include "asterc/r8vide.h"
#include "asterfort/assert.h"
!
integer, intent(in) :: length
character(len=*), optional, intent(out) :: output_string_
integer, optional, intent(in) :: output_unit_
real(kind=8), optional, intent(in) :: value_r_
integer, optional, intent(in) :: value_i_
character(len=*), optional, intent(in) :: value_k_
real(kind=8), optional, intent(in) :: time_
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Print management
!
! Write value in column
!
! --------------------------------------------------------------------------------------------------
!
! In  length           : length of message
! Out output_string    : output string has been created
! In  output_unit      : logical unit
! In  value_r          : real to write
! In  value_i          : integer to write
! In  value_k          : string to write
! In  time             : time to write
!
! --------------------------------------------------------------------------------------------------
!
    integer :: prec_local = 5
    character(len=8) :: for8
    character(len=9) :: for9
    character(len=4) :: for4
    character(len=5) :: for5
    character(len=1) :: for1
    integer :: form_length, output_unit
    integer, parameter :: zlig  = 512
    character(len=6) :: forma
    integer :: minut, heure, second
    character(len=zlig) :: output_string
!
! --------------------------------------------------------------------------------------------------
!
    output_unit = 0
    if (present(output_unit_)) then
        output_unit = output_unit_
    endif
!
    if (present(value_i_)) then
        if (length .le. 9) then
            form_length = 4
            for4(1:2) = '(I'
            write(for1,'(I1)') length
            for4(3:3) = for1
            for4(4:4) = ')'
        else if (length .le. 19) then
            form_length = 5
            for5(1:2) = '(I'
            for5(3:3) = '1'
            write(for1,'(I1)') length-10
            for5(4:4) = for1
            for5(5:5) = ')'
        else
            ASSERT(ASTER_FALSE)
        endif
        if (output_unit .eq. 0) then
            if (form_length .eq. 4) then
                write(output_string,for4) value_i_
            else if (form_length.eq.5) then
                write(output_string,for5) value_i_
            else
                ASSERT(ASTER_FALSE)
            endif
        else
            if (form_length .eq. 4) then
                write(output_unit,for4) value_i_
            else if (form_length.eq.5) then
                write(output_unit,for5) value_i_
            else
                ASSERT(ASTER_FALSE)
            endif
        endif
    elseif (present(value_r_)) then
        if (value_r_ .eq. r8vide()) then
            if (output_unit .eq. 0) then
                write(output_string,'(A)') ' '
            else
                write(output_unit,'(A)') ' '
            endif
        endif
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
            ASSERT(ASTER_FALSE)
        endif
        if (output_unit .eq. 0) then
            if (form_length .eq. 8) then
                write(output_string,for8) value_r_
            else if (form_length.eq.9) then
                write(output_string,for9) value_r_
            else
                ASSERT(ASTER_FALSE)
            endif
        else
            if (form_length .eq. 8) then
                write(output_unit,for8) value_r_
            else if (form_length.eq.9) then
                write(output_unit,for9) value_r_
            else
                ASSERT(ASTER_FALSE)
            endif
        endif
    elseif (present(value_k_)) then 
        if (length .le. 0) then
            forma = '(A)'
        else if (length .gt. zlig) then
            ASSERT(ASTER_FALSE)
        else
            write(forma,40) length
        endif
        ASSERT(output_unit .gt. 0)
        write(output_unit,forma) value_k_(1:length)
    elseif (present(time_)) then 
        if (time_ .lt. 60.d0) then
            write(output_string,10) time_
        else
            if (time_ .le. 3600.d0) then
                minut  = int(time_/60)
                second = int(time_ - (minut*60))
                write(output_string,20) minut,second
            else
                heure  = int(time_/3600)
                minut  = int((time_ - (heure*3600))/60)
                second = int(time_ - (heure*3600) - (minut*60))
                write(output_string,30) heure,minut,second
            endif
        endif
    else
        ASSERT(ASTER_FALSE)
    endif
!
    if (present(output_string_ )) then
        output_string_ = output_string 
    endif
!
10  format (16x               ,f6.3,' s')
20  format (13x      ,i2,' min ',i2,' s')
30  format (i10,' h ',i2,' min ',i2,' s')
40  format ('(A',i3,')')
!
end subroutine
