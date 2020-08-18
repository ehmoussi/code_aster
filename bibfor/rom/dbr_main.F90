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
subroutine dbr_main(cmdPara)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/dbrMainGreedy.h"
#include "asterfort/dbrMainOrtho.h"
#include "asterfort/dbrMainPod.h"
#include "asterfort/dbrMainPodIncr.h"
#include "asterfort/dbrMainTrunc.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
!
type(ROM_DS_ParaDBR), intent(inout) :: cmdPara
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE
!
! Main subroutine to compute base
!
! --------------------------------------------------------------------------------------------------
!
! IO  cmdPara          : datastructure for parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM19_9')
    endif
!
    if (cmdPara%operation .eq. 'POD') then
        call dbrMainPod(cmdPara%paraPod, cmdPara%base)
    elseif (cmdPara%operation .eq. 'POD_INCR') then
        call dbrMainPodIncr(cmdPara%lReuse, cmdPara%paraPod, cmdPara%base)
    elseif (cmdPara%operation .eq. 'GLOUTON') then
        call dbrMainGreedy(cmdPara%paraGreedy, cmdPara%base)
    elseif (cmdPara%operation .eq. 'TRONCATURE') then
        call dbrMainTrunc(cmdPara%paraTrunc, cmdPara%base)
    elseif (cmdPara%operation .eq. 'ORTHO') then
        call dbrMainOrtho(cmdPara%paraOrtho, cmdPara%base)
    else
        ASSERT(ASTER_FALSE)
    endif
!
end subroutine
