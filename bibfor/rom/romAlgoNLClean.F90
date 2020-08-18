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
!
subroutine romAlgoNLClean(paraAlgo)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/romBaseClean.h"
#include "asterfort/nonlinDSTableIOClean.h"
!
type(ROM_DS_AlgoPara), intent(inout) :: paraAlgo
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Solving non-linear problem
!
! Clean ROM algorithm datastructure
!
! --------------------------------------------------------------------------------------------------
!
! IO  paraAlgo         : datastructure for ROM parameters
!
! --------------------------------------------------------------------------------------------------
!
    AS_DEALLOCATE(vi = paraAlgo%v_equa_int)
    if (paraAlgo%l_hrom_corref) then
        AS_DEALLOCATE(vi = paraAlgo%v_equa_sub)
    endif
    call romBaseClean(paraAlgo%ds_empi)
    call nonlinDSTableIOClean(paraAlgo%tablResu)
!
end subroutine
