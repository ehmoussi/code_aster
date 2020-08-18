! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
subroutine dbr_chck_ortho(paraOrtho, lReuse)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
#include "asterfort/romModeChck.h"
!
type(ROM_DS_ParaDBR_ORTHO), intent(in) :: paraOrtho
aster_logical, intent(in) :: lReuse
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Initializations
!
! Some checks - Truncation
!
! --------------------------------------------------------------------------------------------------
!
! In  paraOrtho        : datastructure for orthogonalization parameters
! In  lReuse           : .true. if reuse
!
! --------------------------------------------------------------------------------------------------
!
    type(ROM_DS_Field) :: mode
!
! --------------------------------------------------------------------------------------------------
!
    mode = paraOrtho%ds_empi_init%mode
!
! - Check empiric mode
!
    if (.not. lReuse) then
        call romModeChck(mode)
    endif
!
! - Only on nodal fields 
!
    ASSERT(mode%fieldSupp .eq. 'NOEU')
!
end subroutine
