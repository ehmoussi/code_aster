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

subroutine GetDevice(ds_measure, device_type_, device, device_indx_)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(NL_DS_Measure), intent(in) :: ds_measure
    character(len=*), intent(in) :: device_type_
    type(NL_DS_Device), intent(out) :: device
    integer, optional, intent(out) :: device_indx_
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Measure and statistic management
!
! Get device
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_measure       : datastructure for measure and statistics management
! In  device_type      : type of current device
! Out device           : current device
! Out device_indx      : index of current device
!
! --------------------------------------------------------------------------------------------------
!
    character(len=10) :: device_type
    integer :: i_device, device_indx, nb_device
!
! --------------------------------------------------------------------------------------------------
!
    device_type    = device_type_
!
! - Find device
!
    device_type = device_type_
    nb_device   = ds_measure%nb_device
    device_indx = 0
    do i_device = 1, nb_device
        if (ds_measure%device(i_device)%type .eq. device_type) then
            ASSERT(device_indx.eq.0)
            device_indx = i_device
        endif
    end do
!
! - Get current device
!
    ASSERT(device_indx.ne.0)
    device = ds_measure%device(device_indx)
    if (present(device_indx_)) then
        device_indx_ = device_indx
    endif
!
end subroutine
