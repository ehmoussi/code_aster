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
subroutine nmassx(model, nume_dof, ds_material, cara_elem,&
                  ds_constitutive, list_load, fonact, ds_measure,&
                  sddyna, valinc, solalg, veelem, veasse,&
                  ldccvg, cndonn)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/assvec.h"
#include "asterfort/isfonc.h"
#include "asterfort/ndasva.h"
#include "asterfort/ndynre.h"
#include "asterfort/nmasdi.h"
#include "asterfort/nmasfi.h"
#include "asterfort/nmasva.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmdiri.h"
#include "asterfort/nmfint.h"
#include "asterfort/nmtime.h"
#include "asterfort/nonlinDSVectCombInit.h"
#include "asterfort/nonlinDSVectCombCompute.h"
#include "asterfort/nonlinDSVectCombAddAny.h"
#include "asterfort/nonlinDSVectCombAddHat.h"
!
integer :: ldccvg
integer :: fonact(*)
character(len=19) :: list_load, sddyna
type(NL_DS_Material), intent(in) :: ds_material
type(NL_DS_Constitutive), intent(in) :: ds_constitutive
character(len=24) :: model, nume_dof
type(NL_DS_Measure), intent(inout) :: ds_measure
character(len=24) :: cara_elem
character(len=19) :: solalg(*), valinc(*)
character(len=19) :: veasse(*), veelem(*)
character(len=19) :: cndonn
!
! --------------------------------------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME)
!
! CALCUL DU SECOND MEMBRE POUR LA PREDICTION EN EXPLICITE
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of model
! In  cara_elem        : name of elementary characteristics (field)
! In  ds_material      : datastructure for material parameters
! In  list_load        : name of datastructure for list of loads
! In  nume_dof         : name of numbering object (NUME_DDL)
! In  sddyna           : datastructure for dynamic
! IN  FONACT : FONCTIONNALITES ACTIVEES
! In  ds_constitutive  : datastructure for constitutive laws management
! IO  ds_measure       : datastructure for measure and statistics management
! IN  SDDYNA : SD DYNAMIQUE
! IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
! IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
! IN  VEELEM : VARIABLE CHAPEAU POUR NOM DES VECT_ELEM
! IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
! OUT CNDONN : VECTEUR ASSEMBLE DES FORCES DONNEES
! OUT LDCCVG : CODE RETOUR INTEGRATION DU COMPORTEMENT
!                0 - OK
!                1 - ECHEC DANS L'INTEGRATION : PAS DE RESULTATS
!                2 - ERREUR DANS LES LDC SUR LA NON VERIFICATION DE
!                    CRITERES PHYSIQUES
!                3 - SIZZ NON NUL (DEBORST) ON CONTINUE A ITERER
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: mate, varc_refe
    character(len=19) :: cnffdo, cndfdo, cnfvdo, cnvady, cndumm
    character(len=19) :: vefint, cnfint
    character(len=19) :: vediri, cndiri
    character(len=19) :: disp_prev, vite_prev, acce_prev
    aster_logical :: l_macr
    integer :: iterat
    real(kind=8) :: coeequ
    type(NL_DS_VectComb) :: ds_vectcomb
!
! --------------------------------------------------------------------------------------------------
!
    mate      = ds_material%field_mate
    varc_refe = ds_material%varc_refe
!
! - Initializations
!
    call nonlinDSVectCombInit(ds_vectcomb)
    iterat = 0
    cndumm = '&&CNCHAR.DUMM'
    cnffdo = '&&CNCHAR.FFDO'
    cndfdo = '&&CNCHAR.DFDO'
    cnfvdo = '&&CNCHAR.FVDO'
    cnvady = '&&CNCHAR.FVDY'
    l_macr = isfonc(fonact,'MACR_ELEM_STAT')
!
! - Get hat variables
!
    call nmchex(valinc, 'VALINC', 'DEPMOI', disp_prev)
    call nmchex(valinc, 'VALINC', 'VITMOI', vite_prev)
    call nmchex(valinc, 'VALINC', 'ACCMOI', acce_prev)
!
! - Coefficient for multi-step scheme
!
    coeequ = ndynre(sddyna,'COEF_MPAS_EQUI_COUR')
!
! - Launch timer
!
    call nmtime(ds_measure, 'Init'  , '2nd_Member')
    call nmtime(ds_measure, 'Launch', '2nd_Member')
!
! - Get dead Neumann loads and multi-step dynamic schemes forces
!
    call nmasfi(fonact, veasse, cnffdo, sddyna)
    call nonlinDSVectCombAddAny(cnffdo, +1.d0, ds_vectcomb)
!
! - Get Dirichlet loads
!
    call nmasdi(fonact, veasse, cndfdo)
    call nonlinDSVectCombAddAny(cndfdo, +1.d0, ds_vectcomb)
!
! - Get undead Neumann loads and multi-step dynamic schemes forces
!
    call nmasva(fonact, veasse, cnfvdo, sddyna)
    call nonlinDSVectCombAddAny(cnfvdo, +1.d0, ds_vectcomb)
!
! - Get undead Neumann loads for dynamic
!
    call ndasva(sddyna, veasse, cnvady)
    call nonlinDSVectCombAddAny(cnvady, coeequ, ds_vectcomb)
!
! - Force from sub-structuring
!
    if (l_macr) then
        call nonlinDSVectCombAddHat(veasse, 'CNSSTR', -1.d0, ds_vectcomb)
    endif
!
! - External state variable
!
    call nonlinDSVectCombAddAny(ds_material%fvarc_pred, +1.d0, ds_vectcomb)
!
! - Compute force for Dirichlet boundary conditions (dualized) - BT.LAMBDA
!
    call nmchex(veelem, 'VEELEM', 'CNDIRI', vediri)
    call nmchex(veasse, 'VEASSE', 'CNDIRI', cndiri)
    call nmdiri(model    , ds_material, cara_elem, list_load,&
                disp_prev, vediri     , nume_dof , cndiri   ,&
                sddyna   , vite_prev  , acce_prev)
    call nonlinDSVectCombAddHat(veasse, 'CNDIRI', -1.d0, ds_vectcomb)
!
! - End timer
!
    call nmtime(ds_measure, 'Stop', '2nd_Member')
!
! - Compute internal forces
!
    call nmchex(veasse, 'VEASSE', 'CNFINT', cnfint)
    call nmchex(veelem, 'VEELEM', 'CNFINT', vefint)
    call nmfint(model , mate  , cara_elem, varc_refe , ds_constitutive,&
                fonact, iterat, sddyna   , ds_measure, valinc         ,&
                solalg, ldccvg, vefint)
!
    if (ldccvg .eq. 0) then
! ----- Assemble internal forces
        call assvec('V', cnfint, 1, vefint, [1.d0], nume_dof, ' ', 'ZERO', 1)
! ----- Add internal forces to second member
        call nonlinDSVectCombAddHat(veasse, 'CNFINT', -1.d0, ds_vectcomb)
! ----- Combination
        call nonlinDSVectCombCompute(ds_vectcomb, cndonn)
    endif
!
end subroutine
