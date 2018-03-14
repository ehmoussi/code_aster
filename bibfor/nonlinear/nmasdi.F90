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
!
subroutine nmasdi(list_func_acti, hval_veasse, cndfdo)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/nonlinDSVectCombCompute.h"
#include "asterfort/nonlinDSVectCombAddHat.h"
#include "asterfort/nonlinDSVectCombInit.h"
#include "asterfort/isfonc.h"
!
integer, intent(in) :: list_func_acti(*)
character(len=19), intent(in) :: hval_veasse(*), cndfdo
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Algorithm
!
! Get Dirichlet loads
!
! --------------------------------------------------------------------------------------------------
!
! In  list_func_acti   : list of active functionnalities
! In  hval_veasse      : hat-variable for vectors (node fields)
! In  cndfdo           : name of resultant nodal field
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: l_didi
    type(NL_DS_VectComb) :: ds_vectcomb
!
! --------------------------------------------------------------------------------------------------
!
    l_didi = isfonc(list_func_acti,'DIDI')
!
! - Initializations
!
    call nonlinDSVectCombInit(ds_vectcomb)
!
! - Dirichlet (given displacements) - AFFE_CHAR_MECA
!
    call nonlinDSVectCombAddHat(hval_veasse, 'CNDIDO', 1.d0, ds_vectcomb)
    if (l_didi) then
        call nonlinDSVectCombAddHat(hval_veasse, 'CNDIDI', 1.d0, ds_vectcomb)
    endif
!
! - Dirichlet (given displacements) - AFFE_CHAR_CINE
!
    call nonlinDSVectCombAddHat(hval_veasse, 'CNCINE', 1.d0, ds_vectcomb)
!
! - Combination
!
    call nonlinDSVectCombCompute(ds_vectcomb, cndfdo)
!
end subroutine
