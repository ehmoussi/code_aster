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
subroutine nmassc(list_func_acti, sddyna, ds_contact, hval_veasse,&
                  cnpilo      , cndonn)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infdbg.h"
#include "asterfort/utmess.h"
#include "asterfort/ndasva.h"
#include "asterfort/ndynlo.h"
#include "asterfort/ndynre.h"
#include "asterfort/nmasdi.h"
#include "asterfort/nmasfi.h"
#include "asterfort/nmasva.h"
#include "asterfort/nmdebg.h"
#include "asterfort/isfonc.h"
#include "asterfort/nonlinDSVectCombInit.h"
#include "asterfort/nonlinDSVectCombCompute.h"
#include "asterfort/nonlinDSVectCombAddAny.h"
#include "asterfort/nonlinDSVectCombAddHat.h"
!
integer, intent(in) :: list_func_acti(*)
character(len=19), intent(in) :: sddyna
type(NL_DS_Contact), intent(in) :: ds_contact
character(len=19), intent(in) :: hval_veasse(*)
character(len=19), intent(in) :: cnpilo, cndonn
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Algorithm
!
! Evaluate second member for correction
!
! --------------------------------------------------------------------------------------------------
!
! In  list_func_acti   : list of active functionnalities
! In  sddyna           : datastructure for dynamic
! In  ds_contact       : datastructure for contact management
! In  hval_veasse      : hat-variable for vectors (node fields)
! In  cndonn           : name of nodal field for "given" forces
! In  cnpilo           : name of nodal field for "pilotage" forces
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=19) :: cnffdo, cndfdo, cnfvdo, cnvady
    character(len=19) :: cnffpi, cndfpi
    real(kind=8) :: coeequ
    aster_logical :: l_dyna, l_pilo, l_macr
    type(NL_DS_VectComb) :: ds_vectcomb
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECANONLINE', ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'MECANONLINE11_15')
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
    cnvady = '&&CNCHAR.FVDY'
!
! - Active functionnalities
!
    l_dyna = ndynlo(sddyna,'DYNAMIQUE')
    l_pilo = isfonc(list_func_acti,'PILOTAGE')
    l_macr = isfonc(list_func_acti,'MACR_ELEM_STAT')
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
    if (l_dyna) then
        call ndasva(sddyna, hval_veasse, cnvady)
    endif
!
! - Add dead Neumann loads and multi-step dynamic schemes forces
!
    call nonlinDSVectCombAddAny(cnffdo, +1.d0, ds_vectcomb)
!
! - Add undead Neumann loads and multi-step dynamic schemes forces
!
    call nonlinDSVectCombAddAny(cnfvdo, +1.d0, ds_vectcomb)
!
! - Add internal forces to second member
!
    call nonlinDSVectCombAddHat(hval_veasse, 'CNFINT', -1.d0, ds_vectcomb)
!
! - Add Dirichlet boundary conditions - B.U
!
    call nonlinDSVectCombAddHat(hval_veasse, 'CNBUDI', -1.d0, ds_vectcomb)
!
! - Add force for Dirichlet boundary conditions (dualized) - BT.LAMBDA
!
    call nonlinDSVectCombAddHat(hval_veasse, 'CNDIRI', -1.d0, ds_vectcomb)
!
! - Add Dirichlet loads
!
    call nonlinDSVectCombAddAny(cndfdo, +1.d0, ds_vectcomb)
!
! - Add undead Neumann loads for dynamic
!
    if (l_dyna) then
        coeequ = ndynre(sddyna,'COEF_MPAS_EQUI_COUR')
        call nonlinDSVectCombAddAny(cnvady, coeequ, ds_vectcomb)
    endif
!
! - Add DISCRETE contact force
!
    if (ds_contact%l_cnctdf) then
        call nonlinDSVectCombAddAny(ds_contact%cnctdf, -1.d0, ds_vectcomb)
    endif
!
! - Add LIAISON_UNIL penalized force
!
    if (ds_contact%l_cnunil) then
        call nonlinDSVectCombAddAny(ds_contact%cnunil, -1.d0, ds_vectcomb)
    endif
!
! - Force from sub-structuring
!
    if (l_macr) then
        call nonlinDSVectCombAddHat(hval_veasse, 'CNSSTR', -1.d0, ds_vectcomb)
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
