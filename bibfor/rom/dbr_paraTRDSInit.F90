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
!
subroutine dbr_paraTRDSInit(ds_para_tr)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/romLineicBaseDSInit.h"
#include "asterfort/romBaseDSInit.h"
!
type(ROM_DS_ParaDBR_TR), intent(out) :: ds_para_tr
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Initializations
!
! Initialization of datastructures for parameters - Truncation
!
! --------------------------------------------------------------------------------------------------
!
! Out ds_para_tr       : datastructure for truncation parameters
!
! --------------------------------------------------------------------------------------------------
!
    type(ROM_DS_Empi) :: ds_empi_init
    type(ROM_DS_LineicNumb)  :: ds_lineicnumb
!
! --------------------------------------------------------------------------------------------------
!

!
! - Initialization of datastructure for lineic base numbering
!
    call romLineicBaseDSInit(ds_lineicnumb)
!
! - Initialization of datastructure for empiric modes
!
    call romBaseDSInit(ds_lineicnumb, ds_empi_init)
!
! - General initialisations of datastructure
!
    ds_para_tr%base_init     = ' '
    ds_para_tr%ds_empi_init  = ds_empi_init
    ds_para_tr%model_rom     = ' '
    ds_para_tr%v_equa_rom    => null()
    ds_para_tr%prof_chno_rom = ' '
    ds_para_tr%nb_equa_rom   = 0
    ds_para_tr%idx_gd        = 0
!
end subroutine
