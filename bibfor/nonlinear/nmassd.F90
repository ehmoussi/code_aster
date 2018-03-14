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
subroutine nmassd(list_func_acti, hval_veasse, cnpilo, cndonn)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infdbg.h"
#include "asterfort/utmess.h"
#include "asterfort/isfonc.h"
#include "asterfort/nmdebg.h"
#include "asterfort/nonlinDSVectCombInit.h"
#include "asterfort/nonlinDSVectCombCompute.h"
#include "asterfort/nonlinDSVectCombAddHat.h"
!
integer, intent(in) :: list_func_acti(*)
character(len=19), intent(in) :: hval_veasse(*)
character(len=19), intent(in) :: cnpilo, cndonn
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Algorithm
!
! Evaluate second member for Dirichlet loads (AFFE_CHAR_MECA)
!
! --------------------------------------------------------------------------------------------------
!
! In  list_func_acti   : list of active functionnalities
! In  hval_veasse      : hat-variable for vectors (node fields)
! In  cndonn           : name of nodal field for "given" forces
! In  cnpilo           : name of nodal field for "pilotage" forces
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    aster_logical :: l_didi, l_pilo
    type(NL_DS_VectComb) :: ds_vectcomb
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECANONLINE', ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'MECANONLINE11_16')
    endif
!
! - Initializations
!
    call nonlinDSVectCombInit(ds_vectcomb)
!
! - Active functionnalities
!
    l_didi = isfonc(list_func_acti,'DIDI')
    l_pilo = isfonc(list_func_acti,'PILOTAGE')
!
! - Dirichlet (given displacements) - AFFE_CHAR_MECA
!
    call nonlinDSVectCombAddHat(hval_veasse, 'CNDIDO', +1.d0, ds_vectcomb)
    call nonlinDSVectCombAddHat(hval_veasse, 'CNBUDI', -1.d0, ds_vectcomb)
    if (l_didi) then
        call nonlinDSVectCombAddHat(hval_veasse, 'CNDIDI', 1.d0, ds_vectcomb)
    endif
!
! - Second member (standard)
!
    call nonlinDSVectCombCompute(ds_vectcomb, cndonn)
    if (niv .ge. 2) then
        call nmdebg('VECT', cndonn, 6)
    endif
!
    call nonlinDSVectCombInit(ds_vectcomb)
    if (l_pilo) then
! ----- Get Dirichlet loads (for PILOTAGE)
        call nonlinDSVectCombAddHat(hval_veasse, 'CNDIPI', +1.d0, ds_vectcomb)   
    endif
!
! - Second member (PILOTAGE)
!
    call nonlinDSVectCombCompute(ds_vectcomb, cnpilo)
    if (niv .ge. 2) then
        call nmdebg('VECT', cnpilo, 6)
    endif
!
end subroutine
