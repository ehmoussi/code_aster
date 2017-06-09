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

subroutine romEvalCoefPrep(i_coef_list, ds_multipara)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    integer, intent(in) :: i_coef_list
    type(ROM_DS_MultiPara), intent(inout) :: ds_multipara
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Set values of parameters to evaluate coefficients
!
! --------------------------------------------------------------------------------------------------
!
! In  i_coef_list      : index of coefficient in list of coefficients (VariPara)
! IO  ds_multipara     : datastructure for multiparametric problems
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: i_vari_para, i_eval_para
    integer :: nb_vari_para
    character(len=16) :: para_name
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        if (i_coef_list .eq. 0) then
            call utmess('I', 'ROM5_94')
        else
            call utmess('I', 'ROM5_51', si = i_coef_list)
        endif
    endif
!
! - Get parameters
!
    nb_vari_para = ds_multipara%nb_vari_para
!
! - Set values of parameters
!
    do i_vari_para = 1, nb_vari_para
        i_eval_para = i_vari_para
        if (i_coef_list .eq. 0) then
            ds_multipara%evalcoef%para_vale(i_eval_para) = &
                             ds_multipara%vari_para(i_vari_para)%para_init
        else
            ds_multipara%evalcoef%para_vale(i_eval_para) = &
                             ds_multipara%vari_para(i_vari_para)%para_vale(i_coef_list)
        endif
        if (niv .ge. 2) then
            para_name = ds_multipara%vari_para(i_vari_para)%para_name
            call utmess('I', 'ROM5_52', sk = para_name, &
                        sr = ds_multipara%evalcoef%para_vale(i_eval_para))
        endif
    end do
!
end subroutine
