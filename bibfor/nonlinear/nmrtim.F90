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

subroutine nmrtim(ds_measure, device_type_, time)
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
    real(kind=8), intent(in) :: time
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Measure and statistic management
!
! Save time
!
! --------------------------------------------------------------------------------------------------
!
! IO  ds_measure       : datastructure for measure and statistics management
! In  device_type      : type of device
! In  time             : time to save
!
! --------------------------------------------------------------------------------------------------
!
    integer :: device_indx
    type(NL_DS_Device) :: device
!
! --------------------------------------------------------------------------------------------------
!
    device_indx = 0
!
! - Get current device
!
    call GetDevice(ds_measure, device_type_, device, device_indx)
!
! - Set time for current device
!
    device%time_iter = device%time_iter + time
    device%time_step = device%time_step + time
    device%time_comp = device%time_comp + time
!
! - Set current device
!
    ds_measure%device(device_indx) = device
!
end subroutine
