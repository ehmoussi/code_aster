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
subroutine dbr_DSInit(cmdPara)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/dbrDSInitGreedy.h"
#include "asterfort/dbr_paraDSInit.h"
#include "asterfort/infniv.h"
#include "asterfort/romGreedyAlgoDSInit.h"
#include "asterfort/romSolveDSInit.h"
#include "asterfort/utmess.h"
!
type(ROM_DS_ParaDBR), intent(out) :: cmdPara
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE
!
! Initialization of datastructures
!
! --------------------------------------------------------------------------------------------------
!
! Out cmdPara          : datastructure for parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    type(ROM_DS_ParaDBR_POD)    :: paraPod
    type(ROM_DS_ParaDBR_Greedy) :: paraGreedy
    type(ROM_DS_ParaDBR_TR)     :: paraTrunc
    type(ROM_DS_ParaDBR_ORTHO)  :: paraOrtho
    type(ROM_DS_Solve)          :: solveROM, solveDOM
    type(ROM_DS_MultiPara)      :: multiPara
    type(ROM_DS_AlgoGreedy)     :: algoGreedy
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM19_1')
    endif
!
! - Initialisation of datastructure for solving problems
!
    call romSolveDSInit('ROM', solveROM)
    call romSolveDSInit('DOM', solveDOM)
!
! - Initialisation of datastructure for greedy algorithm
!
    call romGreedyAlgoDSInit(solveDOM, solveROM, algoGreedy)
!
! - Initialization of datastructures for greedy parameters
!
    call dbrDSInitGreedy(multiPara, algoGreedy, paraGreedy)
!
! - Initialization of datastructures for parameters
!
    call dbr_paraDSInit(paraPod, paraGreedy, paraTrunc, paraOrtho,&
                        cmdPara)
!
end subroutine
