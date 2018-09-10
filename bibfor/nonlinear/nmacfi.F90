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
subroutine nmacfi(list_func_acti, hval_veasse, cnffdo, cndfdo)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/nonlinDSVectCombCompute.h"
#include "asterfort/nonlinDSVectCombAddHat.h"
#include "asterfort/nonlinDSVectCombAddDyna.h"
#include "asterfort/nonlinDSVectCombInit.h"
#include "asterfort/isfonc.h"
!
integer, intent(in) :: list_func_acti(*)
character(len=19), intent(in) :: hval_veasse(*), cnffdo, cndfdo
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Algorithm
!
! Get Neumann and Dirichlet loads for initial acceleration 
!
! --------------------------------------------------------------------------------------------------
!
! In  list_func_acti   : list of active functionnalities
! In  hval_veasse      : hat-variable for vectors (node fields)
! In  cnffdo           : name of resultant nodal field for Neumann loads
! In  cndfdo           : name of resultant nodal field for Dirichlet loads
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: l_didi, l_macr, l_sstf
    type(NL_DS_VectComb) :: ds_vectcomb
!
! --------------------------------------------------------------------------------------------------
!
    l_didi = isfonc(list_func_acti,'DIDI')
    l_macr = isfonc(list_func_acti,'MACR_ELEM_STAT')
    l_sstf = isfonc(list_func_acti,'SOUS_STRUC')
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
    call nonlinDSVectCombInit(ds_vectcomb)
!
! - Dead Neumann forces
!
    call nonlinDSVectCombAddHat(hval_veasse, 'CNFEDO', 1.d0, ds_vectcomb)
!
! - Force from sub-structuring
!
    if (l_macr) then
        call nonlinDSVectCombAddHat(hval_veasse, 'CNSSTR', -1.d0, ds_vectcomb)
    endif
!
! - Sub-structuring force
!
    if (l_sstf) then
        call nonlinDSVectCombAddHat(hval_veasse, 'CNSSTF', 1.d0, ds_vectcomb)
    endif
!
! - Combination
!
    call nonlinDSVectCombCompute(ds_vectcomb, cnffdo)
!
end subroutine
