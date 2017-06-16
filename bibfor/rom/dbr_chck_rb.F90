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
subroutine dbr_chck_rb(operation, ds_para_rb, l_reuse)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/utmess.h"
#include "asterfort/romMultiParaChck.h"
!
character(len=16), intent(in) :: operation
type(ROM_DS_ParaDBR_RB), intent(in) :: ds_para_rb
aster_logical, intent(in) :: l_reuse
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Initializations
!
! Some checks - For RB methods
!
! --------------------------------------------------------------------------------------------------
!
! In  operation        : type of method
! In  ds_para_rb       : datastructure for parameters (RB)
! In  l_reuse          : .true. if reuse
!
! --------------------------------------------------------------------------------------------------
!
    if (l_reuse) then
        call utmess('F','ROM2_13', sk = operation)
    endif
!
! - Check data for multiparametric problems
!
    call romMultiParaChck(ds_para_rb%multipara)
!
! - Specific checks for DEFI_BASE_REDUITE
!
    if (ds_para_rb%multipara%nb_vari_coef .eq. 0) then
        call utmess('F', 'ROM2_43')
    endif
!
end subroutine
