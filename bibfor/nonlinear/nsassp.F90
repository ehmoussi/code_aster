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
subroutine nsassp(list_func_acti, ds_material, ds_contact, ds_algorom,&
                  hval_veasse   , cnpilo     , cndonn)
!
use NonLin_Datastructure_type
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/isfonc.h"
#include "asterfort/nmasdi.h"
#include "asterfort/nmasfi.h"
#include "asterfort/nmasva.h"
#include "asterfort/infdbg.h"
#include "asterfort/utmess.h"
#include "asterfort/nmdebg.h"
#include "asterfort/nonlinDSVectCombInit.h"
#include "asterfort/nonlinDSVectCombCompute.h"
#include "asterfort/nonlinDSVectCombAddAny.h"
#include "asterfort/nonlinDSVectCombAddHat.h"
!
integer, intent(in) :: list_func_acti(*)
type(NL_DS_Material), intent(in) :: ds_material
type(NL_DS_Contact), intent(in) :: ds_contact
type(ROM_DS_AlgoPara), intent(in) :: ds_algorom
character(len=19), intent(in) :: hval_veasse(*)
character(len=19), intent(in) :: cnpilo, cndonn
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Algorithm
!
! Evaluate second member for prediction (static)
!
! --------------------------------------------------------------------------------------------------
!
! In  list_func_acti   : list of active functionnalities
! In  ds_material      : datastructure for material parameters
! In  ds_contact       : datastructure for contact management
! In  ds_algorom       : datastructure for ROM parameters
! In  hval_veasse      : hat-variable for vectors (node fields)
! In  cndonn           : name of nodal field for "given" forces
! In  cnpilo           : name of nodal field for "pilotage" forces
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=19) :: cnffdo, cndfdo, cnfvdo, cnffpi, cndfpi
    aster_logical :: l_macr, l_pilo
    type(NL_DS_VectComb) :: ds_vectcomb
!
! --------------------------------------------------------------------------------------------------
!    
    call infdbg('MECANONLINE', ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'MECANONLINE11_19')
    endif
!
! - Initializations
!
    call nonlinDSVectCombInit(ds_vectcomb)
    cnffdo = '&&CNCHAR.FFDO'
    cnffpi = '&&CNCHAR.FFPI'
    cndfdo = '&&CNCHAR.DFDO'
    cndfpi = '&&CNCHAR.DFPI'
    cnfvdo = '&&CNCHAR.FVDO'
!
! - Active functionnalities
!
    l_macr = isfonc(list_func_acti,'MACR_ELEM_STAT')
    l_pilo = isfonc(list_func_acti,'PILOTAGE')
!
! - Get dead Neumann loads and multi-step dynamic schemes forces
!
    call nmasfi(list_func_acti, hval_veasse, cnffdo)
    call nonlinDSVectCombAddAny(cnffdo, +1.d0, ds_vectcomb)
!
! - Get Dirichlet loads
!
    call nmasdi(list_func_acti, hval_veasse, cndfdo)
    call nonlinDSVectCombAddAny(cndfdo, +1.d0, ds_vectcomb)
!
! - Get undead Neumann loads and multi-step dynamic schemes forces
!
    call nmasva(list_func_acti, hval_veasse, cnfvdo)
    call nonlinDSVectCombAddAny(cnfvdo, +1.d0, ds_vectcomb)
!
! - Add DISCRETE contact force
!
    if (ds_contact%l_cnctdf) then
        call nonlinDSVectCombAddAny(ds_contact%cnctdf, -1.d0, ds_vectcomb)
    endif
!
! - Add CONTINUE/XFEM contact force
!
    if (ds_contact%l_cneltc) then
        call nonlinDSVectCombAddAny(ds_contact%cneltc, -1.d0, ds_vectcomb)
    endif
    if (ds_contact%l_cneltf) then
        call nonlinDSVectCombAddAny(ds_contact%cneltf, -1.d0, ds_vectcomb)
    endif
!
! - Force from sub-structuring
!
    if (l_macr) then
        call nonlinDSVectCombAddHat(hval_veasse, 'CNSSTR', +1.d0, ds_vectcomb)
    endif
!
! - External state variable
!
    call nonlinDSVectCombAddAny(ds_material%fvarc_pred, +1.d0, ds_vectcomb)
!
! - Get Dirichlet boundary conditions - B.U
!
    call nonlinDSVectCombAddHat(hval_veasse, 'CNBUDI', -1.d0, ds_vectcomb)
!
! - Get force for Dirichlet boundary conditions (dualized) - BT.LAMBDA
!
    call nonlinDSVectCombAddHat(hval_veasse, 'CNDIRI', -1.d0, ds_vectcomb)
!
! - Add internal forces to second member
!
    if (ds_algorom%phase.eq.'CORR_EF') then
        call nonlinDSVectCombAddHat(hval_veasse, 'CNFINT', -1.d0, ds_vectcomb)
    else
        call nonlinDSVectCombAddHat(hval_veasse, 'CNFNOD', -1.d0, ds_vectcomb)
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
! ----- Get dead Neumann loads (for PILOTAGE)
        call nonlinDSVectCombAddHat(hval_veasse, 'CNFEPI', +1.d0, ds_vectcomb)
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
