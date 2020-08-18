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
subroutine dbr_clean_pod(cmdPara)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/romBaseClean.h"
#include "asterfort/romFieldClean.h"
#include "asterfort/romTableClean.h"
#include "asterfort/romResultClean.h"
#include "asterfort/romSnapClean.h"
!
type(ROM_DS_ParaDBR), intent(inout) :: cmdPara
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE
!
! Clean datastructures for POD
!
! --------------------------------------------------------------------------------------------------
!
! IO  cmdPara           : datastructure for parameters 
!
! --------------------------------------------------------------------------------------------------
!
    call romBaseClean(cmdPara%ds_empi)
    call romResultClean()
    call romTableClean(cmdPara%para_pod%tablReduCoor)
    call romSnapClean(cmdPara%para_pod%snap)
!
end subroutine
