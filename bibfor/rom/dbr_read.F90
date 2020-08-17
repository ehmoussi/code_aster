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
subroutine dbr_read(cmdPara)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/getres.h"
#include "asterfort/assert.h"
#include "asterfort/dbrReadGreedy.h"
#include "asterfort/dbr_read_ortho.h"
#include "asterfort/dbr_read_pod.h"
#include "asterfort/dbrReadTrunc.h"
#include "asterfort/gcucon.h"
#include "asterfort/getvid.h"
#include "asterfort/getvtx.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
!
type(ROM_DS_ParaDBR), intent(inout) :: cmdPara
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE
!
! Read parameters
!
! --------------------------------------------------------------------------------------------------
!
! IO  cmdPara          : datastructure for parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=16) :: k16bid, operation, resultType
    character(len=8) :: resultOutName, resultReuseName
    integer :: ireuse
    aster_logical :: lReuse
    type(ROM_DS_Result) :: resultOut
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM19_2')
    endif
!
! - Initializations
!
    operation       = ' '
    resultOutName   = ' '
    resultReuseName = ' '
!
! - Output datastructure
!
    call getres(resultOutName, resultType, k16bid)
    ASSERT(resultType .eq. 'MODE_EMPI')
    resultOut%resultType    = resultType
    resultOut%resultName    = resultOutName
    resultOut%nbStore       = 0
    resultOut%lTablFromResu = ASTER_FALSE
!
! - Is REUSE?
!
    call gcucon(resultOutName, 'MODE_EMPI', ireuse)
    lReuse = ireuse .ne. 0
    if (lReuse) then
        call getvid(' ', 'BASE', scal = resultReuseName)
        if (resultOutName .ne. resultReuseName) then
            call utmess('F', 'SUPERVIS2_79', sk = 'BASE')
        endif
    endif
!
! - Type of ROM methods
!
    call getvtx(' ', 'OPERATION', scal = operation)
    if (operation(1:3) .eq. 'POD') then
        call dbr_read_pod(operation, cmdPara%paraPod)
    elseif (operation .eq. 'GLOUTON') then
        call dbrReadGreedy(cmdPara%paraGreedy)
    elseif (operation .eq. 'TRONCATURE') then
        call dbrReadTrunc(cmdPara%paraTrunc)
    elseif (operation .eq. 'ORTHO') then
        call dbr_read_ortho(cmdPara%paraOrtho)
    else
        ASSERT(ASTER_FALSE)
    endif
!
! - Save parameters in datastructure
!
    cmdPara%operation = operation
    cmdPara%resultOut = resultOut
    cmdPara%lReuse    = lReuse
!
end subroutine
