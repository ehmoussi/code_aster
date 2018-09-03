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
!
subroutine op0053()
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/infmaj.h"
#include "asterfort/titre.h"
#include "asterfort/dbr_chck.h"
#include "asterfort/dbr_DSInit.h"
#include "asterfort/dbr_init_algo.h"
#include "asterfort/dbr_init_base.h"
#include "asterfort/dbr_para_info.h"
#include "asterfort/dbr_read.h"
#include "asterfort/dbr_main.h"
#include "asterfort/dbr_clean.h"
!
! --------------------------------------------------------------------------------------------------
!
!   DEFI_BASE_REDUITE
!
! --------------------------------------------------------------------------------------------------
!
    type(ROM_DS_ParaDBR) :: ds_para
!
! --------------------------------------------------------------------------------------------------
!
    call titre()
    call infmaj()
!
! - Initialization of datastructures
!
    call dbr_DSInit(ds_para)
!
! - Read parameters
!
    call dbr_read(ds_para)
!
! - Prepare datastructure for empiric modes
!
    call dbr_init_base(ds_para)
!
! - Init algorithm
!
    call dbr_init_algo(ds_para)
!
! - Check parameters
!
    call dbr_chck(ds_para)
!
! - Print informations
!
    call dbr_para_info(ds_para)
!
! - Compute the POD by the main function
!
    call dbr_main(ds_para)
!
! - Clean datastructures
!
    call dbr_clean(ds_para)
!
end subroutine
