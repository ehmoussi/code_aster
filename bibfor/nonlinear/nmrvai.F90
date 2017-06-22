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

subroutine nmrvai(ds_measure, device_type_, phasis, input_count, output_count)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/GetDevice.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(NL_DS_Measure), intent(inout) :: ds_measure
    character(len=*), intent(in) :: device_type_
    character(len=1), optional, intent(in) :: phasis
    integer, optional, intent(in) :: input_count
    integer, optional, intent(out) :: output_count
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Measure and statistic management
!
! Counters management
!
! --------------------------------------------------------------------------------------------------
!
! IO  ds_measure       : datastructure for measure and statistics management
! In  device_type      : type of current device
! In  phasis           : phasis (time step, Newton iteration, all computation)
! In  input_count      : value to increase counter
! Out output_count     : value of counter
!
! --------------------------------------------------------------------------------------------------
!
    character(len=16) :: operation
    integer :: device_indx
    type(NL_DS_Device) :: device
    aster_logical :: l_count_add
!
! --------------------------------------------------------------------------------------------------
!
    operation = ' '
!
! - Get current device
!
    call GetDevice(ds_measure, device_type_, device, device_indx)
!
! - Which type of operation ?
!
    if (present(input_count)) then
        ASSERT(.not.present(output_count))
        operation = 'Write'
    elseif (present(output_count)) then
        ASSERT(.not.present(input_count))
        operation = 'Read'
    else
        ASSERT(.false.)
    endif 
!
! - Write
!
    if (operation .eq. 'Write') then
        l_count_add = device%l_count_add
        if (present(phasis)) then
            if (phasis.eq.'N') then
                if (l_count_add) then
                    device%count_iter = device%count_iter + input_count
                else
                    device%count_iter = input_count
                endif
            elseif (phasis.eq.'P') then
                if (l_count_add) then
                    device%count_step = device%count_step + input_count
                else
                    device%count_step = input_count
                endif
            elseif (phasis.eq.'T') then
                if (l_count_add) then
                    device%count_comp = device%count_comp + input_count
                else
                    device%count_comp = input_count
                endif
            else
                ASSERT(.false.)
            endif
        else
            if (l_count_add) then
                device%count_iter = device%count_iter + input_count
            else
                device%count_iter = input_count
            endif
            if (l_count_add) then
                device%count_step = device%count_step + input_count
            else
                device%count_step = input_count
            endif
            if (l_count_add) then
                device%count_comp = device%count_comp + input_count
            else
                device%count_comp = input_count
            endif
        endif
        ds_measure%device(device_indx) = device
    elseif (operation .eq. 'Read') then
        if (phasis.eq.'N') then
            output_count = device%count_iter
        elseif (phasis.eq.'P') then
            output_count = device%count_step
        elseif (phasis.eq.'T') then
            output_count = device%count_comp
        else
            ASSERT(.false.)
        endif
    else
        ASSERT(.false.)
    endif
!
end subroutine
