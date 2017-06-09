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

subroutine romVariParaClean(ds_varipara)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/assert.h"
!
! person_in_charge: mickael.abbas at edf.fr
! aslint: disable=W1403
!
    type(ROM_DS_VariPara), intent(inout) :: ds_varipara
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Variation of parameters for multiparametric problems - Delete objects
!
! --------------------------------------------------------------------------------------------------
!
! IO  ds_varipara      : datastructure for multiparametric problems - Variations
!
! --------------------------------------------------------------------------------------------------
!
    AS_DEALLOCATE(vr   = ds_varipara%para_vale)
!
end subroutine
