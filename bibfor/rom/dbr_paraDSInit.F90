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
subroutine dbr_paraDSInit(paraPod, paraGreedy, paraTrunc, paraOrtho, cmdPara)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
!
type(ROM_DS_ParaDBR_POD), intent(in) :: paraPod
type(ROM_DS_ParaDBR_Greedy), intent(in) :: paraGreedy
type(ROM_DS_ParaDBR_TR), intent(in) :: paraTrunc
type(ROM_DS_ParaDBR_ORTHO), intent(in) :: paraOrtho
type(ROM_DS_ParaDBR), intent(out) :: cmdPara
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Initializations
!
! Initialization of datastructures for parameters
!
! --------------------------------------------------------------------------------------------------
!
! In  paraPod          : datastructure for POD parameters
! In  paraGreedy       : datastructure for parameters (Greedy)
! In  paraTrunc        : datastructure for truncation parameters
! In  paraOrtho        : datastructure for orthogonalization parameters
! Out cmdPara          : datastructure for parameters
!
! --------------------------------------------------------------------------------------------------
!
    cmdPara%paraPod    = paraPod
    cmdPara%paraGreedy = paraGreedy
    cmdPara%paraTrunc  = paraTrunc
    cmdPara%paraOrtho  = paraOrtho
!
end subroutine
