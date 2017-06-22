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

subroutine romEvalCoefInit(nb_vari_para, vari_para, ds_evalcoef)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    integer, intent(in) :: nb_vari_para
    type(ROM_DS_VariPara), intent(in) :: vari_para(5)
    type(ROM_DS_EvalCoef), intent(inout) :: ds_evalcoef
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Initializations
!
! Initialisation for evaluation of coefficients
!
! --------------------------------------------------------------------------------------------------
!
! In  nb_vari_para     : number of variables 
! In  vari_para        : datastructure for multiparametric problems - Variations
! IO  ds_evalcoef      : datastructure for multiparametric problems - Evaluation
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_vari_para, i_eval_para
!
! --------------------------------------------------------------------------------------------------
!
    do i_vari_para = 1, nb_vari_para
        i_eval_para = i_vari_para
        ds_evalcoef%para_name(i_eval_para) = vari_para(i_vari_para)%para_name
    end do
    ds_evalcoef%nb_para = nb_vari_para
!
end subroutine
