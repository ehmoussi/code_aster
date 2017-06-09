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

subroutine romMultiParaDSInit(ds_multicoef_v, ds_multicoef_m, ds_varipara, ds_evalcoef,&
                              ds_multipara)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterc/r8vide.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(ROM_DS_MultiCoef), intent(in)  :: ds_multicoef_v
    type(ROM_DS_MultiCoef), intent(in)  :: ds_multicoef_m
    type(ROM_DS_VariPara), intent(in)   :: ds_varipara
    type(ROM_DS_EvalCoef), intent(in)   :: ds_evalcoef
    type(ROM_DS_MultiPara), intent(out) :: ds_multipara
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Initializations
!
! Initialisation of datastructure for multiparametric problems
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_multicoef_v   : datastructure for multiparametric problems - Coefficients (vectors)
! In  ds_multicoef_m   : datastructure for multiparametric problems - Coefficients (matrix)
! In  ds_varipara      : datastructure for multiparametric problems - Variations
! In  ds_evalcoef      : datastructure for multiparametric problems - Evaluation
! Out ds_multipara     : datastructure for multiparametric problems
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM5_43')
    endif
!
! - General
!
    ds_multipara%syst_type       = ' '
    ds_multipara%nb_matr         = 0
    ds_multipara%matr_name(:)    = ' '
    ds_multipara%matr_type(:)    = ' '
    ds_multipara%vect_name       = ' '
    ds_multipara%vect_type       = ' '
    ds_multipara%prod_mode(1)    = '&&OP0053.PRODMODE_1'
    ds_multipara%prod_mode(2)    = '&&OP0053.PRODMODE_2'
    ds_multipara%prod_mode(3)    = '&&OP0053.PRODMODE_3'
    ds_multipara%prod_mode(4)    = '&&OP0053.PRODMODE_4'
    ds_multipara%prod_mode(5)    = '&&OP0053.PRODMODE_5'
    ds_multipara%prod_mode(6)    = '&&OP0053.PRODMODE_6'
    ds_multipara%prod_mode(7)    = '&&OP0053.PRODMODE_7'
    ds_multipara%prod_mode(8)    = '&&OP0053.PRODMODE_8'
    ds_multipara%matr_coef(:)    = ds_multicoef_m
    ds_multipara%vect_coef       = ds_multicoef_v
!
! - Initializations of variation of parameters for multiparametric problems
!
    ds_multipara%nb_vari_coef    = 0
    ds_multipara%nb_vari_para    = 0
    ds_multipara%type_vari_coef  = ' '
    ds_multipara%vari_para(:)    = ds_varipara
!
! - Initializations of evaluation of coefficients for multiparametric problems
!
    ds_multipara%evalcoef        = ds_evalcoef
!
end subroutine
