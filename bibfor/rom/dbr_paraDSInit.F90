! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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
subroutine dbr_paraDSInit(ds_empi, ds_para_pod, ds_para_rb, ds_para)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/r8vide.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
!
type(ROM_DS_Empi), intent(in) :: ds_empi
type(ROM_DS_ParaDBR_POD), intent(in) :: ds_para_pod
type(ROM_DS_ParaDBR_RB), intent(in) :: ds_para_rb
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
! Out ds_para          : datastructure for parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM5_14')
    endif
!
! - General initialisations of datastructure
!
    ds_para%operation    = ' '
    ds_para%result_out   = ' '
    ds_para%field_iden   = ' '
    ds_para%para_pod     = ds_para_pod
    ds_para%para_rb      = ds_para_rb
    ds_para%ds_empi      = ds_empi
    ds_para%l_reuse      = .false._1
!
end subroutine
