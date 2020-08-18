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
subroutine dbr_clean_tr(paraTrunc)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/as_deallocate.h"
#include "asterfort/romBaseClean.h"
!
type(ROM_DS_ParaDBR_TR ), intent(inout) :: paraTrunc
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE
!
! Clean datastructures for truncation
!
! --------------------------------------------------------------------------------------------------
!
! IO  paraTrunc        : datastructure for parameters (truncation)
!
! --------------------------------------------------------------------------------------------------
!
    AS_DEALLOCATE(vi = paraTrunc%v_equa_rom)
    call romBaseClean(paraTrunc%ds_empi_init)
!
end subroutine
