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

subroutine romMultiCoefClean(ds_multicoef)
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
!
    type(ROM_DS_MultiCoef), intent(inout) :: ds_multicoef
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Delete coefficients for multiparametric problems
!
! --------------------------------------------------------------------------------------------------
!
! IO  ds_multicoef     : datastructure for multiparametric problems - Coefficients
!
! --------------------------------------------------------------------------------------------------
!
    if (ds_multicoef%l_real) then
        AS_DEALLOCATE(vr  = ds_multicoef%coef_real)
    endif
    if (ds_multicoef%l_cplx) then
        AS_DEALLOCATE(vc  = ds_multicoef%coef_cplx)
    endif
!
end subroutine
