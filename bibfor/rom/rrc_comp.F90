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
subroutine rrc_comp(ds_para)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/rrc_comp_prim.h"
#include "asterfort/rrc_comp_dual.h"
!
type(ROM_DS_ParaRRC), intent(in) :: ds_para
!
! --------------------------------------------------------------------------------------------------
!
! REST_REDUIT_COMPLET - Compute
!
! Compute
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_para          : datastructure for parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM6_20')
    endif
!
! - For primal field
!
    call rrc_comp_prim(ds_para)
!
! - For dual field
!
    if (ds_para%l_prev_dual) then
        call rrc_comp_dual(ds_para)
    endif
!
end subroutine
