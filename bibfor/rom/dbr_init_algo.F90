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
subroutine dbr_init_algo(cmdPara)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/dbrInitAlgoGreedy.h"
#include "asterfort/dbrInitAlgoOrtho.h"
#include "asterfort/dbr_init_algo_pod.h"
#include "asterfort/dbrInitAlgoTrunc.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
!
type(ROM_DS_ParaDBR), intent(inout) :: cmdPara
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE
!
! Initializations for algorithm
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
        call utmess('I', 'ROM19_5')
    endif
!
    if (cmdPara%operation(1:3) .eq. 'POD') then
        call dbr_init_algo_pod()
    elseif (cmdPara%operation .eq. 'GLOUTON') then
        call dbrInitAlgoGreedy(cmdPara%paraGreedy)
    elseif (cmdPara%operation .eq. 'TRONCATURE') then
        call dbrInitAlgoTrunc(cmdPara%paraTrunc)
    elseif (cmdPara%operation .eq. 'ORTHO') then
        call dbrInitAlgoOrtho()
    else
        ASSERT(ASTER_FALSE)
    endif
!
end subroutine
