! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
subroutine dbr_paraDSInit(ds_para_pod, ds_para_rb, ds_para_tr, ds_para)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
!
type(ROM_DS_ParaDBR_POD), intent(in) :: ds_para_pod
type(ROM_DS_ParaDBR_RB), intent(in) :: ds_para_rb
type(ROM_DS_ParaDBR_TR), intent(in) :: ds_para_tr
type(ROM_DS_ParaDBR), intent(out) :: ds_para
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Initializations
!
! Initialization of datastructures for parameters
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_empi          : datastructure for empiric modes
! In  ds_para_pod      : datastructure for POD parameters
! In  ds_para_rb       : datastructure for RB parameters
! In  ds_para_tr       : datastructure for truncation parameters
! Out ds_para          : datastructure for parameters
!
! --------------------------------------------------------------------------------------------------
!
    ds_para%para_pod     = ds_para_pod
    ds_para%para_rb      = ds_para_rb
    ds_para%para_tr      = ds_para_tr
!
end subroutine
