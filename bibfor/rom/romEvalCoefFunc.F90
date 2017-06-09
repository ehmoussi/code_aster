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

subroutine romEvalCoefFunc(ds_evalcoef, ds_multicoef, i_coef_list)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/fointe.h"
#include "asterfort/fointc.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(ROM_DS_EvalCoef), intent(in) :: ds_evalcoef
    type(ROM_DS_MultiCoef), intent(inout) :: ds_multicoef
    integer, intent(in) :: i_coef_list
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Evaluate functions for coefficients
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_evalcoef      : datastructure for multiparametric problems - Evaluation
! IO  ds_multicoef     : datastructure for multiparametric problems - Coefficients
! In  i_coef_list      : index of coefficient in list of coefficients (VariPara)
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: l_func, l_real, l_cplx, l_cste
    real(kind=8) :: cplx_real, cplx_imag, real_real
    character(len=8) :: func_name
    integer :: iret
!
! --------------------------------------------------------------------------------------------------
!
    l_cste      = ds_multicoef%l_cste
    l_func      = ds_multicoef%l_func
    func_name   = ds_multicoef%func_name
    l_cplx      = ds_multicoef%l_cplx
    l_real      = ds_multicoef%l_real
! 
! - Evaluate function
!
    if (l_func) then
        if (l_real) then
            call fointe('F', func_name,&
                        ds_evalcoef%nb_para,&
                        ds_evalcoef%para_name,&
                        ds_evalcoef%para_vale,&
                        real_real, iret)
            ds_multicoef%coef_real(i_coef_list) = real_real
        elseif (l_cplx) then
            call fointc('F', func_name,&
                        ds_evalcoef%nb_para,&
                        ds_evalcoef%para_name,&
                        ds_evalcoef%para_vale,&
                        cplx_real, cplx_imag, iret)
            ds_multicoef%coef_cplx(i_coef_list) = dcmplx(cplx_real, cplx_imag)
        else
            ASSERT(.false.)
        endif
    elseif (l_cste) then
! - Already done at initialization
    else
        ASSERT(.false.)
    endif
!
end subroutine
