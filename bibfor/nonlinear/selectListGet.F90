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
subroutine selectListGet(selectList, nume_inst, inst, l_select)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/utacli.h"
!
type(NL_DS_SelectList), intent(in) :: selectList
integer, intent(in) :: nume_inst
real(kind=8), intent(in) :: inst
aster_logical, intent(out) :: l_select
!
! --------------------------------------------------------------------------------------------------
!
! Select list management
!
! Return if current inst is selected
!
! --------------------------------------------------------------------------------------------------
!
! In  selectList       : datastructure for select list
! In  nume_inst        : index of current inst step
! In  inst             : current inst
! Out l_select         : .true. is current inst is selected
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: tolerance, precision
    integer :: nb_value, freq_step, nb_found
    aster_logical :: l_abso, l_by_freq
    real(kind=8) :: reste
!
! --------------------------------------------------------------------------------------------------
!
    l_select = ASTER_FALSE
!
! - Get values
!
    nb_value   = selectList%nb_value
    precision  = selectList%precision
    l_abso     = selectList%l_abso
    freq_step  = selectList%freq_step
    l_by_freq  = selectList%l_by_freq
!
! - Compute tolerance
!
    if (l_abso) then
        tolerance = abs(inst)
    else
        tolerance = abs(inst)*precision   
    endif
!
! - Find
!
    if (l_by_freq) then
        reste    = mod(nume_inst, freq_step)
        l_select = nint(reste) .eq. 0
    else
        call utacli(inst, selectList%list_value, nb_value, tolerance, nb_found)
        l_select = nb_found .ge. 0
    endif
!
end subroutine
