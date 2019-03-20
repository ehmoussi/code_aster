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
subroutine nonlinDSSystemCreate(ds_system)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
!
type(NL_DS_System), intent(out) :: ds_system
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Non-linear system
!
! Create non-linear system management datastructure
!
! --------------------------------------------------------------------------------------------------
!
! Out ds_system        : datastructure for non-linear system management
!
! --------------------------------------------------------------------------------------------------
!
    ds_system%l_pred_cnfnod = ASTER_FALSE
    ds_system%l_pred_cnfint = ASTER_FALSE
    ds_system%l_pred_full   = ASTER_FALSE
    ds_system%code_pred     = '&&OP00XX.CODE_PRED'
    ds_system%vefnod        = '&&OP00XX.VEFNOD'
    ds_system%cnfnod        = '&&OP00XX.CNFNOD'
    ds_system%vefint        = '&&OP00XX.VEFINT'
    ds_system%cnfint        = '&&NMCH5P.CNFINT'
    ds_system%cnpred        = '&&OP00XX.CNPRED'
!
end subroutine
