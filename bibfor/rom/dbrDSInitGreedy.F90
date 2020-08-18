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
! aslint: disable=W1403
!
subroutine dbrDSInitGreedy(multiPara, algoGreedy, paraGreedy)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/r8vide.h"
!
type(ROM_DS_MultiPara), intent(in)   :: multiPara
type(ROM_DS_AlgoGreedy), intent(in)  :: algoGreedy
type(ROM_DS_ParaDBR_Greedy), intent(out) :: paraGreedy
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE 
!
! Initialization of datastructures for parameters - For greedy
!
! --------------------------------------------------------------------------------------------------
!
! In  multiPara        : datastructure for multiparametric problems
! In  algoGreedy       : datastructure for Greedy algorithm
! Out paraGreedy       : datastructure for parameters (Greedy)
!
! --------------------------------------------------------------------------------------------------
!
    paraGreedy%solver     = '&&OP0053.SOLVER'
    paraGreedy%multipara  = multiPara
    paraGreedy%algoGreedy = algoGreedy
!
end subroutine
