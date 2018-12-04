! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
subroutine nmrini(ds_measure, phasis)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
!
type(NL_DS_Measure), intent(inout) :: ds_measure
character(len=1), intent(in) :: phasis
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Measure and statistic management
!
! Reset times and counters
!
! --------------------------------------------------------------------------------------------------
!
! IO  ds_measure       : datastructure for measure and statistics management
! In  phasis           : phasis (time step, Newton iteration, all computation
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_device, nb_device 
!
! --------------------------------------------------------------------------------------------------
!
    nb_device  = ds_measure%nb_device
!
! - Reset all timers
!
    do i_device = 1, nb_device  
        if (phasis .eq. 'T') then
            ds_measure%device(i_device)%time_comp = 0.d0
            ds_measure%device(i_device)%time_step = 0.d0
            ds_measure%device(i_device)%time_iter = 0.d0
        elseif (phasis .eq. 'P') then
            ds_measure%device(i_device)%time_step = 0.d0
            ds_measure%device(i_device)%time_iter = 0.d0
        elseif (phasis .eq. 'N') then
            ds_measure%device(i_device)%time_iter = 0.d0
        else
            ASSERT(ASTER_FALSE)
        endif
    end do
!
! - Reset all counters
!
    do i_device = 1, nb_device  
        if (phasis .eq. 'T') then
            ds_measure%device(i_device)%count_comp = 0
            ds_measure%device(i_device)%count_step = 0
            ds_measure%device(i_device)%count_iter = 0
        elseif (phasis .eq. 'P') then
            ds_measure%device(i_device)%count_step = 0
            ds_measure%device(i_device)%count_iter = 0
        elseif (phasis .eq. 'N') then
            ds_measure%device(i_device)%count_iter = 0
        else
            ASSERT(ASTER_FALSE)
        endif
    end do
!
end subroutine
