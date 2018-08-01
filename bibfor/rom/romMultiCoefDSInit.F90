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
subroutine romMultiCoefDSInit(ds_multicoef)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterc/r8vide.h"
#include "asterfort/assert.h"
!
type(ROM_DS_MultiCoef), intent(out) :: ds_multicoef
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Initializations
!
! Initialisation of datastructure for multiparametric problems - Coefficients
!
! --------------------------------------------------------------------------------------------------
!
! Out ds_multicoef     : datastructure for multiparametric problems - Coefficients
!
! --------------------------------------------------------------------------------------------------
!
    ds_multicoef%l_func         = ASTER_FALSE
    ds_multicoef%l_cste         = ASTER_FALSE
    ds_multicoef%l_cplx         = ASTER_FALSE
    ds_multicoef%l_real         = ASTER_FALSE
    ds_multicoef%func_name      = ' '
    ds_multicoef%coef_cste_cplx = dcmplx(0.d0, 0.d0)
    ds_multicoef%coef_cste_real = 0.d0
    ds_multicoef%coef_cplx      => null()
    ds_multicoef%coef_real      => null()
!
end subroutine
