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
subroutine ndassp(model          , nume_dof  , ds_material   , cara_elem  ,&
                  ds_constitutive, ds_measure, list_func_acti, ds_contact ,&
                  sddyna         ,&
                  hval_incr      , hval_algo , hval_veelem   , hval_veasse,&
                  ldccvg         , cndonn    , sdnume )
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/isfonc.h"
#include "asterfort/ndasva.h"
#include "asterfort/ndynin.h"
#include "asterfort/ndynre.h"
#include "asterfort/nmaint.h"
#include "asterfort/nmasdi.h"
#include "asterfort/nmasfi.h"
#include "asterfort/nmasva.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmfint.h"
#include "asterfort/infdbg.h"
#include "asterfort/utmess.h"
#include "asterfort/nmdebg.h"
#include "asterfort/nonlinDSVectCombInit.h"
#include "asterfort/nonlinDSVectCombCompute.h"
#include "asterfort/nonlinDSVectCombAddAny.h"
#include "asterfort/nonlinDSVectCombAddHat.h"
!
integer, intent(in) :: list_func_acti(*)
character(len=19), intent(in) :: sddyna, sdnume
type(NL_DS_Constitutive), intent(in) :: ds_constitutive
type(NL_DS_Material), intent(in) :: ds_material
type(NL_DS_Measure), intent(inout) :: ds_measure
character(len=24), intent(in) :: model, nume_dof
character(len=24), intent(in) :: cara_elem
type(NL_DS_Contact), intent(in) :: ds_contact
character(len=19), intent(in) :: hval_algo(*), hval_incr(*)
character(len=19), intent(in) :: hval_veasse(*), hval_veelem(*)
character(len=19), intent(in) :: cndonn
integer, intent(out) :: ldccvg
!
! --------------------------------------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME - PREDICTION)
!
! CALCUL DU SECOND MEMBRE POUR LA PREDICTION - DYNAMIQUE
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of model
! In  cara_elem        : name of elementary characteristics (field)
! In  ds_material      : datastructure for material parameters
! In  nume_dof         : name of numbering object (NUME_DDL)
! In  sddyna           : datastructure for dynamic
! IO  ds_measure       : datastructure for measure and statistics management
! In  ds_constitutive  : datastructure for constitutive laws management
! In  iter_newt        : index of current Newton iteration
! In  sddyna           : datastructure for dynamic
! IO  ds_measure       : datastructure for measure and statistics management
! In  hval_incr        : hat-variable for incremental values fields
! In  hval_algo        : hat-variable for algorithms fields
! In  ds_contact       : datastructure for contact management
! IN  SDNUME : SD NUMEROTATION
! OUT CNDONN : VECTEUR ASSEMBLE DES FORCES DONNEES
! Out ldccvg           : indicator from integration of behaviour
!                -1 : PAS D'INTEGRATION DU COMPORTEMENT
!                 0 : CAS DE FONCTIONNEMENT NORMAL
!                 1 : ECHEC DE L'INTEGRATION DE LA LDC
!                 3 : SIZZ PAS NUL POUR C_PLAN DEBORST
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=19) :: cnffdo, cndfdo, cnfvdo, cnvady, cndumm
    character(len=19) :: vefint, cnfint
    aster_logical :: l_disp, l_vite, l_acce, l_macr
    integer :: iter_newt
    real(kind=8) :: coeequ
    type(NL_DS_VectComb) :: ds_vectcomb
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECANONLINE', ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'MECANONLINE11_20')
    endif
!
! - Initializations
!
    call nonlinDSVectCombInit(ds_vectcomb)
    ldccvg = -1
    iter_newt = 0
    cndumm = '&&CNCHAR.DUMM'
    cnffdo = '&&CNCHAR.FFDO'
    cndfdo = '&&CNCHAR.DFDO'
    cnfvdo = '&&CNCHAR.FVDO'
    cnvady = '&&CNCHAR.FVDY'
    l_disp = ndynin(sddyna,'FORMUL_DYNAMIQUE').eq.1
    l_vite = ndynin(sddyna,'FORMUL_DYNAMIQUE').eq.2
    l_acce = ndynin(sddyna,'FORMUL_DYNAMIQUE').eq.3
    l_macr = isfonc(list_func_acti,'MACR_ELEM_STAT')
!
! - Coefficient for multi-step scheme
!
    coeequ = ndynre(sddyna,'COEF_MPAS_EQUI_COUR')
!
! - Get dead Neumann loads and multi-step dynamic schemes forces
!
    call nmasfi(list_func_acti, hval_veasse, cnffdo, sddyna)
    call nonlinDSVectCombAddAny(cnffdo, +1.d0, ds_vectcomb)
!
! - Get Dirichlet loads
!
    call nmasdi(list_func_acti, hval_veasse, cndfdo)
    call nonlinDSVectCombAddAny(cndfdo, +1.d0, ds_vectcomb)
!
! - Get undead Neumann loads and multi-step dynamic schemes forces
!
    call nmasva(list_func_acti, hval_veasse, cnfvdo, sddyna)
    call nonlinDSVectCombAddAny(cnfvdo, +1.d0, ds_vectcomb)
!
! - Get undead Neumann loads for dynamic
!
    call ndasva(sddyna, hval_veasse, cnvady)
    call nonlinDSVectCombAddAny(cnvady, coeequ, ds_vectcomb)
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
        call nonlinDSVectCombAddHat(hval_veasse, 'CNSSTR', -1.d0, ds_vectcomb)
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
! - Compute internal forces
!
    call nmchex(hval_veasse, 'VEASSE', 'CNFINT', cnfint)
    call nmchex(hval_veelem, 'VEELEM', 'CNFINT', vefint)
    call nmfint(model         , cara_elem      ,&
                ds_material   , ds_constitutive,&
                list_func_acti, iter_newt      , sddyna, ds_measure,&
                hval_incr     , hval_algo      ,&
                vefint        , ldccvg   )
!
    if (ldccvg .eq. 0) then
! ----- Assemble internal forces
        call nmaint(nume_dof, list_func_acti, sdnume,&
                    vefint  , cnfint)
! ----- Add internal forces to second member
        call nonlinDSVectCombAddHat(hval_veasse, 'CNFINT', -1.d0, ds_vectcomb)
! ----- Combination
        call nonlinDSVectCombCompute(ds_vectcomb, cndonn)
! ----- Debug
        if (niv .ge. 2) then
            call nmdebg('VECT', cndonn, 6)
        endif
    endif
!
end subroutine
