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
subroutine nsassp(model     , nume_dof   , list_load , fonact    ,&
                  ds_measure, valinc     , veelem    , veasse    , cnpilo,&
                  cndonn    , ds_material, ds_contact, matass,&
                  ds_algorom)
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
#include "asterfort/nmbudi.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmtime.h"
#include "asterfort/nonlinDSVectCombInit.h"
#include "asterfort/nonlinDSVectCombCompute.h"
#include "asterfort/nonlinDSVectCombAddAny.h"
#include "asterfort/nonlinDSVectCombAddHat.h"
!
integer :: fonact(*)
character(len=19) :: list_load, matass
character(len=24) :: model, nume_dof
type(NL_DS_Material), intent(in) :: ds_material
type(NL_DS_Measure), intent(inout) :: ds_measure
type(NL_DS_Contact), intent(in) :: ds_contact
character(len=19) :: veasse(*), veelem(*), valinc(*)
character(len=19) :: cnpilo, cndonn
type(ROM_DS_AlgoPara), intent(in) :: ds_algorom
!
! --------------------------------------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME - PREDICTION)
!
! CALCUL DU SECOND MEMBRE POUR LA PREDICTION - STATIQUE
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of model
! In  ds_material      : datastructure for material parameters
! In  list_load        : name of datastructure for list of loads
! In  nume_dof         : name of numbering object (NUME_DDL)
! IN  FONACT : FONCTIONNALITES ACTIVEES
! In  ds_contact       : datastructure for contact management
! IO  ds_measure       : datastructure for measure and statistics management
! IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
! IN  VEELEM : VARIABLE CHAPEAU POUR NOM DES VECT_ELEM
! IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
! OUT CNPILO : VECTEUR ASSEMBLE DES FORCES PILOTEES
! OUT CNDONN : VECTEUR ASSEMBLE DES FORCES DONNEES
! IN  MATASS : SD MATRICE ASSEMBLEE
!
! --------------------------------------------------------------------------------------------------
!
    character(len=19) :: cnffdo, cndfdo, cnfvdo, cnffpi, cndfpi
    character(len=19) :: vebudi, cnbudi
    character(len=19) :: cndiri
    character(len=19) :: disp_prev
    aster_logical :: l_macr, l_pilo
    type(NL_DS_VectComb) :: ds_vectcomb
!
! --------------------------------------------------------------------------------------------------
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
    l_macr = isfonc(fonact,'MACR_ELEM_STAT')
    l_pilo = isfonc(fonact,'PILOTAGE')
!
! - Get hat variables
!
    call nmchex(valinc, 'VALINC', 'DEPMOI', disp_prev)
!
! - Launch timer
!
    call nmtime(ds_measure, 'Init'  , '2nd_Member')
    call nmtime(ds_measure, 'Launch', '2nd_Member')
!
! - Get dead Neumann loads and multi-step dynamic schemes forces
!
    call nmasfi(fonact, veasse, cnffdo)
    call nonlinDSVectCombAddAny(cnffdo, +1.d0, ds_vectcomb)
!
! - Get Dirichlet loads
!
    call nmasdi(fonact, veasse, cndfdo)
    call nonlinDSVectCombAddAny(cndfdo, +1.d0, ds_vectcomb)
!
! - Get undead Neumann loads and multi-step dynamic schemes forces
!
    call nmasva(fonact, veasse, cnfvdo)
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
        call nonlinDSVectCombAddHat(veasse, 'CNSSTR', +1.d0, ds_vectcomb)
    endif
!
! - External state variable
!
    call nonlinDSVectCombAddAny(ds_material%fvarc_pred, +1.d0, ds_vectcomb)
!
! - Compute Dirichlet boundary conditions - B.U
!
    call nmchex(veasse, 'VEASSE', 'CNBUDI', cnbudi)
    call nmchex(veelem, 'VEELEM', 'CNBUDI', vebudi)
    call nmbudi(model, nume_dof, list_load, disp_prev, vebudi,&
                cnbudi, matass)
    call nonlinDSVectCombAddHat(veasse, 'CNBUDI', -1.d0, ds_vectcomb)
!
! - Get force for Dirichlet boundary conditions (dualized) - BT.LAMBDA
!
    call nmchex(veasse, 'VEASSE', 'CNDIRI', cndiri)
    call nonlinDSVectCombAddHat(veasse, 'CNDIRI', -1.d0, ds_vectcomb)
!
! - Add internal forces to second member
!
    if (ds_algorom%phase.eq.'CORR_EF') then
        call nonlinDSVectCombAddHat(veasse, 'CNFINT', -1.d0, ds_vectcomb)
    else
        call nonlinDSVectCombAddHat(veasse, 'CNFNOD', -1.d0, ds_vectcomb)
    endif
!
! - Second member (standard)
!
    call nonlinDSVectCombCompute(ds_vectcomb, cndonn)
!
    call nonlinDSVectCombInit(ds_vectcomb)
    if (l_pilo) then
! ----- Get dead Neumann loads (for PILOTAGE)
        call nonlinDSVectCombAddHat(veasse, 'CNFEPI', +1.d0, ds_vectcomb)
! ----- Get Dirichlet loads (for PILOTAGE)
        call nonlinDSVectCombAddHat(veasse, 'CNDIPI', +1.d0, ds_vectcomb)   
    endif
!
! - Second member (PILOTAGE)
!
    call nonlinDSVectCombCompute(ds_vectcomb, cnpilo)
!
! - End timer
!
    call nmtime(ds_measure, 'Stop', '2nd_Member')
!
end subroutine
