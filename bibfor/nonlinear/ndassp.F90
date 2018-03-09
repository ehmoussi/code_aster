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
subroutine ndassp(model          , nume_dof , ds_material, cara_elem,&
                  ds_constitutive, list_load, ds_measure , fonact, ds_contact,&
                  sddyna         , valinc   , solalg     , veelem, veasse    ,&
                  ldccvg         , cndonn   , sdnume     , matass)
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
#include "asterfort/nmbudi.h"
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
character(len=19) :: list_load, sddyna, sdnume, matass
type(NL_DS_Constitutive), intent(in) :: ds_constitutive
type(NL_DS_Material), intent(in) :: ds_material
type(NL_DS_Measure), intent(inout) :: ds_measure
character(len=24) :: model, nume_dof
character(len=24) :: cara_elem
type(NL_DS_Contact), intent(in) :: ds_contact
character(len=19) :: solalg(*), valinc(*)
character(len=19) :: veasse(*), veelem(*)
character(len=19) :: cndonn
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
! In  list_load        : name of datastructure for list of loads
! In  nume_dof         : name of numbering object (NUME_DDL)
! In  sddyna           : datastructure for dynamic
! IO  ds_measure       : datastructure for measure and statistics management
! In  ds_constitutive  : datastructure for constitutive laws management
! IN  FONACT : FONCTIONNALITES ACTIVEES
! IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
! IN  VEELEM : VARIABLE CHAPEAU POUR NOM DES VECT_ELEM
! IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
! In  ds_contact       : datastructure for contact management
! IN  SDNUME : SD NUMEROTATION
! IN  MATASS  : SD MATRICE ASSEMBLEE
! OUT CNDONN : VECTEUR ASSEMBLE DES FORCES DONNEES
! OUT LDCCVG : CODE RETOUR DE L'INTEGRATION DU COMPORTEMENT
!                -1 : PAS D'INTEGRATION DU COMPORTEMENT
!                 0 : CAS DU FONCTIONNEMENT NORMAL
!                 1 : ECHEC DE L'INTEGRATION DE LA LDC
!                 2 : ERREUR SUR LA NON VERIF. DE CRITERES PHYSIQUES
!                 3 : SIZZ PAS NUL POUR C_PLAN DEBORST
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: mate, varc_refe
    character(len=19) :: cnffdo, cndfdo, cnfvdo, cnvady, cndumm
    character(len=19) :: vebudi, cnbudi
    character(len=19) :: vefint, cnfint
    character(len=19) :: vediri, cndiri
    character(len=19) :: disp_prev, acce_prev
    character(len=19) :: vect_lagr
    aster_logical :: l_disp, l_vite, l_acce, l_macr
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
    ldccvg = -1
    iterat = 0
    cndumm = '&&CNCHAR.DUMM'
    cnffdo = '&&CNCHAR.FFDO'
    cndfdo = '&&CNCHAR.DFDO'
    cnfvdo = '&&CNCHAR.FVDO'
    cnvady = '&&CNCHAR.FVDY'
    l_disp  = ndynin(sddyna,'FORMUL_DYNAMIQUE').eq.1
    l_vite  = ndynin(sddyna,'FORMUL_DYNAMIQUE').eq.2
    l_acce  = ndynin(sddyna,'FORMUL_DYNAMIQUE').eq.3
    l_macr = isfonc(fonact,'MACR_ELEM_STAT')
!
! - Get hat variables
!
    call nmchex(valinc, 'VALINC', 'DEPMOI', disp_prev)
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
! - Add DISCRETE contact force
!
    if (ds_contact%l_cnctdf) then
        call nonlinDSVectCombAddAny(ds_contact%cnctdf, -1.d0, ds_vectcomb)
    endif
!
! - Add CONTINUE/XFEM contact force
!
!    if (ds_contact%l_cneltc) then
!        call nonlinDSVectCombAddAny(ds_contact%cneltc, -1.d0, ds_vectcomb)
!    endif
!    if (ds_contact%l_cneltf) then
!        call nonlinDSVectCombAddAny(ds_contact%cneltf, -1.d0, ds_vectcomb)
!    endif
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
! - WHich vector for Lagrange multipliers
!
    if (l_disp) then
        vect_lagr = disp_prev
    else if (l_vite) then
!       VILAINE GLUTE POUR L'INSTANT
        vect_lagr = disp_prev
    else if (l_acce) then
        vect_lagr = acce_prev
    else
        ASSERT(.false.)
    endif
!
! - Compute Dirichlet boundary conditions - B.U
!
    call nmchex(veasse, 'VEASSE', 'CNBUDI', cnbudi)
    call nmchex(veelem, 'VEELEM', 'CNBUDI', vebudi)
    call nmbudi(model, nume_dof, list_load, vect_lagr, vebudi,&
                cnbudi, matass)
    call nonlinDSVectCombAddHat(veasse, 'CNBUDI', -1.d0, ds_vectcomb)
!
! - Compute force for Dirichlet boundary conditions (dualized) - BT.LAMBDA
!
    call nmchex(veelem, 'VEELEM', 'CNDIRI', vediri)
    call nmchex(veasse, 'VEASSE', 'CNDIRI', cndiri)
    call nmdiri(model    , ds_material, cara_elem, list_load,&
                disp_prev, vediri     , nume_dof , cndiri   )
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
    call nmfint(model, mate  , cara_elem, varc_refe, ds_constitutive,&
                fonact, iterat, sddyna, ds_measure, valinc         ,&
                solalg, ldccvg, vefint)
!
    if (ldccvg .eq. 0) then
! ----- Assemble internal forces
        call nmaint(nume_dof, fonact, vefint,&
                    cnfint, sdnume, ds_contact)
! ----- Add internal forces to second member
        call nonlinDSVectCombAddHat(veasse, 'CNFINT', -1.d0, ds_vectcomb)
! ----- Combination
        call nonlinDSVectCombCompute(ds_vectcomb, cndonn)
    endif
!
end subroutine
