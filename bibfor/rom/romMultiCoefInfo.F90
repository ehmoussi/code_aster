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

subroutine romMultiCoefInfo(ds_multicoef)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(ROM_DS_MultiCoef), intent(in) :: ds_multicoef
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Informations about multiparametric problems
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_multicoef     : datastructure for multiparametric problems - Coefficients
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: valr(2)
!
! --------------------------------------------------------------------------------------------------
!
    if (ds_multicoef%l_cplx) then
        if (ds_multicoef%l_cste) then
            valr(1) = real(ds_multicoef%coef_cste_cplx)
            valr(2) = dimag(ds_multicoef%coef_cste_cplx)
            call utmess('I', 'ROM3_41', nr = 2, valr = valr)
        elseif (ds_multicoef%l_func) then
            call utmess('I', 'ROM3_43', sk = ds_multicoef%func_name)
        else
            ASSERT(.false.)
        endif
    elseif (ds_multicoef%l_real) then
        if (ds_multicoef%l_cste) then
            call utmess('I', 'ROM3_42', sr = ds_multicoef%coef_cste_real)
        elseif (ds_multicoef%l_func) then
            call utmess('I', 'ROM3_44', sk = ds_multicoef%func_name)
        else
            ASSERT(.false.)
        endif
    else
        ASSERT(.false.)
    endif
!
end subroutine
