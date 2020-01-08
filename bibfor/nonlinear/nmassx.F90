! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
subroutine nmassx(list_func_acti, sddyna, hval_veasse, ds_system,&
                  cndonn)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/isfonc.h"
#include "asterfort/ndasva.h"
#include "asterfort/ndynre.h"
#include "asterfort/nmasdi.h"
#include "asterfort/nmasfi.h"
#include "asterfort/nmasva.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmdebg.h"
#include "asterfort/utmess.h"
#include "asterfort/infdbg.h"
#include "asterfort/nonlinDSVectCombInit.h"
#include "asterfort/nonlinDSVectCombCompute.h"
#include "asterfort/nonlinDSVectCombAddAny.h"
#include "asterfort/nonlinDSVectCombAddHat.h"
!
integer, intent(in) :: list_func_acti(*)
character(len=19), intent(in) :: sddyna
character(len=19), intent(in) :: hval_veasse(*)
type(NL_DS_System), intent(in) :: ds_system
character(len=19), intent(in) :: cndonn
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Algorithm
!
! Evaluate second member for explicit algorithm
!
! --------------------------------------------------------------------------------------------------
!
! In  list_func_acti   : list of active functionnalities
! In  sddyna           : datastructure for dynamic
! In  hval_veasse      : hat-variable for vectors (node fields)
! In  ds_system        : datastructure for non-linear system management
! In  cndonn           : name of nodal field for "given" forces
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=19) :: cnffdo, cndfdo, cnfvdo, cnvady
    aster_logical :: l_macr
    real(kind=8) :: coeequ
    type(NL_DS_VectComb) :: ds_vectcomb
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECANONLINE', ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'MECANONLINE11_18')
    endif
!
! - Initializations
!
    call nonlinDSVectCombInit(ds_vectcomb)
    cnffdo = '&&CNCHAR.FFDO'
    cndfdo = '&&CNCHAR.DFDO'
    cnfvdo = '&&CNCHAR.FVDO'
    cnvady = '&&CNCHAR.FVDY'
!
! - Active functionnalities
!
    l_macr = isfonc(list_func_acti,'MACR_ELEM_STAT')
!
! - Coefficient for multi-step scheme
!
    coeequ = ndynre(sddyna,'COEF_MPAS_EQUI_COUR')
!
! - Get dead Neumann loads and multi-step dynamic schemes forces
!
    call nmasfi(list_func_acti, hval_veasse, cnffdo, sddyna)
!
! - Get Dirichlet loads
!
    call nmasdi(list_func_acti, hval_veasse, cndfdo)
!
! - Get undead Neumann loads and multi-step dynamic schemes forces
!
    call nmasva(list_func_acti, hval_veasse, cnfvdo, sddyna)
!
! - Get undead Neumann loads for dynamic
!
    call ndasva(sddyna, hval_veasse, cnvady)
!
! - Add undead Neumann loads for dynamic
!
    call nonlinDSVectCombAddAny(cnvady, coeequ, ds_vectcomb)
!
! - Add dead Neumann loads and multi-step dynamic schemes forces
!
    call nonlinDSVectCombAddAny(cnffdo, +1.d0, ds_vectcomb)
!
! - Add undead Neumann loads and multi-step dynamic schemes forces
!
    call nonlinDSVectCombAddAny(cnfvdo, +1.d0, ds_vectcomb)
!
! - Add Dirichlet loads
!
    call nonlinDSVectCombAddAny(cndfdo, +1.d0, ds_vectcomb)
!
! - Add Force from sub-structuring
!
    if (l_macr) then
        call nonlinDSVectCombAddHat(hval_veasse, 'CNSSTR', -1.d0, ds_vectcomb)
    endif
!
! - Add force for Dirichlet boundary conditions (dualized) - BT.LAMBDA
!
    call nonlinDSVectCombAddHat(hval_veasse, 'CNDIRI', -1.d0, ds_vectcomb)
!
! - Add internal forces to second member
!
    call nonlinDSVectCombAddAny(ds_system%cnfint, -1.d0, ds_vectcomb)
!
! - Second member
!
    call nonlinDSVectCombCompute(ds_vectcomb, cndonn)
    if (niv .ge. 2) then
        call nmdebg('VECT', cndonn, 6)
    endif
!
end subroutine
