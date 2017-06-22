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

subroutine romMultiParaCoefInit(ds_multipara)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/romEvalCoefInit.h"
#include "asterfort/romMultiCoefInit.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(ROM_DS_MultiPara), intent(inout) :: ds_multipara
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Initializations of coefficients
!
! --------------------------------------------------------------------------------------------------
!
! IO  ds_multipara     : datastructure for multiparametric problems
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: i_matr
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM2_32')
    endif
!
! - Initialisation for evaluation of coefficients
!
    call romEvalCoefInit(ds_multipara%nb_vari_para,&
                         ds_multipara%vari_para   ,&
                         ds_multipara%evalcoef)
!
! - Allocate list of coefficients and set them if constant
!
    do i_matr = 1,  ds_multipara%nb_matr
        call romMultiCoefInit(ds_multipara%nb_vari_coef, ds_multipara%matr_coef(i_matr))
    end do
    call romMultiCoefInit(ds_multipara%nb_vari_coef, ds_multipara%vect_coef)
!
end subroutine
