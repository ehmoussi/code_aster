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
subroutine rrcInit(cmdPara)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/rrcInfo.h"
#include "asterfort/rscrsd.h"
#include "asterfort/utmess.h"
#include "asterfort/rrc_init_dual.h"
#include "asterfort/rrc_init_prim.h"
#include "asterfort/romTableRead.h"
!
type(ROM_DS_ParaRRC), intent(inout) :: cmdPara
!
! --------------------------------------------------------------------------------------------------
!
! REST_REDUIT_COMPLET - Initializations
!
! Initializations
!
! --------------------------------------------------------------------------------------------------
!
! IO  cmdPara          : datastructure for parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    type(ROM_DS_Result) :: resultDom, resultRom
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM16_2')
    endif
!
! - Get parameters
!
    resultRom = cmdPara%resultRom
    resultDom = cmdPara%resultDom
!
! - Get reduced coordinates
!
    call romTableRead(cmdPara%tablReduCoor)
!
! - Create output result datastructure
!
    call rscrsd('G', resultDom%resultName, resultDom%resultType, resultDom%nbStore)
!
! - Initializations for primal base
!
    call rrc_init_prim(cmdPara)
!
! - Initializations for dual base
!
    if (cmdPara%l_prev_dual) then
        call rrc_init_dual(cmdPara)
    endif
!
! - Print parameters (debug)
!
    if (niv .ge. 2) then
        call rrcInfo(cmdPara)
    endif
!
end subroutine
