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
subroutine dbr_clean(cmdPara)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/dbrCleanGreedy.h"
#include "asterfort/dbrCleanOrtho.h"
#include "asterfort/dbrCleanPod.h"
#include "asterfort/dbrCleanTrunc.h"
#include "asterfort/romBaseClean.h"
#include "asterfort/romResultClean.h"
!
type(ROM_DS_ParaDBR), intent(inout) :: cmdPara
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE
!
! Clean datastructures
!
! --------------------------------------------------------------------------------------------------
!
! IO  cmdPara          : datastructure for parameters
!
! --------------------------------------------------------------------------------------------------
!
    call romBaseClean(cmdPara%base)
    call romResultClean()
!
    if (cmdPara%operation(1:3) .eq. 'POD') then
        call dbrCleanPod(cmdPara%paraPod)
    elseif (cmdPara%operation .eq. 'GLOUTON') then
        call dbrCleanGreedy(cmdPara%paraGreedy)
    elseif (cmdPara%operation .eq. 'TRONCATURE') then
        call dbrCleanTrunc(cmdPara%paraTrunc)
    elseif (cmdPara%operation .eq. 'ORTHO') then
        call dbrCleanOrtho(cmdPara%paraOrtho)
    else
        ASSERT(ASTER_FALSE)
    endif
!
end subroutine
