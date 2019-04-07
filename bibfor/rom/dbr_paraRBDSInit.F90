! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
subroutine dbr_paraRBDSInit(ds_multipara, ds_algoGreedy, ds_para_rb)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/r8vide.h"
!
type(ROM_DS_MultiPara), intent(in)   :: ds_multipara
type(ROM_DS_AlgoGreedy), intent(in)  :: ds_algoGreedy
type(ROM_DS_ParaDBR_RB), intent(out) :: ds_para_rb
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Initializations
!
! Initialization of datastructures for parameters - POD methods
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_multipara     : datastructure for multiparametric problems
! In  ds_algoGreedy    : datastructure for Greedy algorithm
! Out ds_para_rb       : datastructure for RB parameters
!
! --------------------------------------------------------------------------------------------------
!
    ds_para_rb%solver     = '&&OP0053.SOLVER'
    ds_para_rb%multipara  = ds_multipara
    ds_para_rb%algoGreedy = ds_algoGreedy
!
end subroutine
