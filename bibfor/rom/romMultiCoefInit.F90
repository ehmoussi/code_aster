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

subroutine romMultiCoefInit(nb_vari_coef, ds_multicoef)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/as_allocate.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    integer, intent(in) :: nb_vari_coef
    type(ROM_DS_MultiCoef), intent(inout) :: ds_multicoef
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Initializations
!
! Allocate list of coefficients and set them if constant
!
! --------------------------------------------------------------------------------------------------
!
! In  nb_vari_coef     : nombre de fois où les coefficients vont varier
! IO  ds_multicoef     : datastructure for multiparametric problems - Coefficients
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: l_cplx, l_real, l_cste
    integer :: i_para_vale
!
! --------------------------------------------------------------------------------------------------
!
    l_real = ds_multicoef%l_real
    l_cplx = ds_multicoef%l_cplx
    l_cste = ds_multicoef%l_cste
!
! - Allocate list of coefficients (include initial value)
!
    if (l_real) then
        AS_ALLOCATE(vr = ds_multicoef%coef_real, size = nb_vari_coef+1)
    elseif (l_cplx) then
        AS_ALLOCATE(vc = ds_multicoef%coef_cplx, size = nb_vari_coef+1)
    else
        ASSERT(.false.)
    endif
!
! - Set list of coefficients if it's constant
!
    if (l_cste) then
        do i_para_vale = 1, nb_vari_coef+1
            if (l_real) then
                ds_multicoef%coef_real(i_para_vale) = ds_multicoef%coef_cste_real
            elseif (l_cplx) then
                ds_multicoef%coef_cplx(i_para_vale) = ds_multicoef%coef_cste_cplx
            else
                ASSERT(.false.)
            endif
        end do
    endif
!
end subroutine
