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
#include "asterfort/utmess.h"
#include "asterfort/infniv.h"
#include "asterfort/dbr_main_pod.h"
#include "asterfort/dbr_main_podincr.h"
#include "asterfort/dbr_main_rb.h"
#include "asterfort/dbr_main_tr.h"
#include "asterfort/dbr_main_ortho.h"
!
type(ROM_DS_ParaDBR), intent(inout) :: cmdPara
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Compute
!
! Main subroutine to compute empiric modes
!
! --------------------------------------------------------------------------------------------------
!
! IO  cmdPara          : datastructure for parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=8) :: resultNameOut
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM7_9')
    endif
!
    if (cmdPara%operation .eq. 'POD') then
        call dbr_main_pod(cmdPara%para_pod, cmdPara%field_iden, cmdPara%ds_empi)
    elseif (cmdPara%operation .eq. 'POD_INCR') then
        call dbr_main_podincr(cmdPara%l_reuse   , cmdPara%para_pod,&
                              cmdPara%field_iden, cmdPara%ds_empi)
    elseif (cmdPara%operation .eq. 'GLOUTON') then
        call dbr_main_rb(cmdPara%para_rb, cmdPara%ds_empi)
    elseif (cmdPara%operation .eq. 'TRONCATURE') then
        resultNameOut = cmdPara%ds_empi%base
        call dbr_main_tr(cmdPara%para_tr, resultNameOut)
    elseif (cmdPara%operation .eq. 'ORTHO') then
        call dbr_main_ortho(cmdPara%para_ortho, cmdPara%field_iden, cmdPara%ds_empi)
    else
        ASSERT(ASTER_FALSE)
    endif
!
end subroutine
