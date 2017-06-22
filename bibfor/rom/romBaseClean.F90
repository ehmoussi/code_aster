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

subroutine romBaseClean(ds_empi)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/as_deallocate.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(ROM_DS_Empi), intent(inout) :: ds_empi
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Clean empiric modes base
!
! --------------------------------------------------------------------------------------------------
!
! IO  ds_empi          : datastructure for parameters
!
! --------------------------------------------------------------------------------------------------
!
    if (ds_empi%base_type .eq. 'LINEIQUE') then
       AS_DEALLOCATE(vi = ds_empi%ds_lineic%v_nume_pl)
       AS_DEALLOCATE(vi = ds_empi%ds_lineic%v_nume_sf)
    endif
!
end subroutine
