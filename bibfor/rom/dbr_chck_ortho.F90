! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
subroutine dbr_chck_ortho(ds_para_ortho, l_reuse)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/utmess.h"
#include "asterfort/romModeChck.h"
!
type(ROM_DS_ParaDBR_ORTHO), intent(in) :: ds_para_ortho
aster_logical, intent(in) :: l_reuse
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Initializations
!
! Some checks - Truncation
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_para_ortho    : datastructure for orthogonalization parameters
! In  l_reuse          : .true. if reuse
!
! --------------------------------------------------------------------------------------------------
!
    type(ROM_DS_Field) :: ds_mode
!
! --------------------------------------------------------------------------------------------------
!
    ds_mode = ds_para_ortho%ds_empi_init%ds_mode
!
! - Check empiric mode
!
    if (.not. l_reuse) then
        call romModeChck(ds_mode)
    endif
!
end subroutine
