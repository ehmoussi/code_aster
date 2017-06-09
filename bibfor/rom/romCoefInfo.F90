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

subroutine romCoefInfo(object_type, object_name_, i_coef, ds_multicoef)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=1), intent(in)       :: object_type
    character(len=8), intent(in)       :: object_name_
    integer, intent(in)                :: i_coef
    type(ROM_DS_MultiCoef), intent(in) :: ds_multicoef
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Initializations
!
! Information about coefficients
!
! --------------------------------------------------------------------------------------------------
!
! In  object_type      : type of object (VECT or MATR)
! In  object_name      : name of object
! In  i_coef           : index of coefficient
! In  ds_multicoef     : datastructure for multiparametric problems - Coefficients
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: l_real, l_cplx
    real(kind=8) :: cplx_real, cplx_imag, real_real, valr(2)
    character(len=8) :: object_name
!
! --------------------------------------------------------------------------------------------------
!
    l_cplx    = ds_multicoef%l_cplx
    l_real    = ds_multicoef%l_real

    if (object_name_ .eq. ' ') then
        object_name = '<NoName>'
    else
        object_name = object_name_
    endif

    if (l_cplx) then
        cplx_real = real(ds_multicoef%coef_cplx(i_coef))
        cplx_imag = dimag(ds_multicoef%coef_cplx(i_coef))
        valr(1) = cplx_real
        valr(2) = cplx_imag
    else
        real_real = ds_multicoef%coef_real(i_coef)
    endif
!
! - Print
!
    if (object_type .eq. 'V') then
        if (l_real) then
            call utmess('I', 'ROM5_45', sk = object_name, sr = real_real)
        else
            call utmess('I', 'ROM5_46', sk = object_name, nr = 2, valr = valr)
        endif
    elseif (object_type .eq. 'M') then
        if (l_real) then
            call utmess('I', 'ROM5_47', sk = object_name, sr = real_real)
        else
            call utmess('I', 'ROM5_48', sk = object_name, nr = 2, valr = valr)
        endif
    else
        ASSERT(.false.)
    endif
!
end subroutine
