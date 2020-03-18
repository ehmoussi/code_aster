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
! aslint: disable=W1504
!
subroutine nmfcor(model          , nume_dof   , ds_material   , cara_elem  , ds_system,&
                  ds_constitutive, list_load  , list_func_acti, ds_algopara, nume_inst,&
                  iter_newt      , ds_measure , sddisc        , sddyna     , sdnume   ,&
                  sderro         , ds_contact , hval_incr     , hval_algo  , hhoField,&
                  hval_meelem    , hval_veelem    , hval_veasse, hval_measse   , matass   ,&
                  lerrit)
!
use NonLin_Datastructure_type
use HHO_type
use HHO_comb_module, only : hhoPrepMatrix
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infdbg.h"
#include "asterfort/isfonc.h"
#include "asterfort/nmaint.h"
#include "asterfort/nonlinLoadDirichletCompute.h"
#include "asterfort/nmforc_corr.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmchfi.h"
#include "asterfort/nmcret.h"
#include "asterfort/nmctcd.h"
#include "asterfort/ndynin.h"
#include "asterfort/ndynlo.h"
#include "asterfort/nonlinRForceCompute.h"
#include "asterfort/nmfint.h"
#include "asterfort/nmfocc.h"
#include "asterfort/nmltev.h"
#include "asterfort/nmrigi.h"
#include "asterfort/nmtime.h"
#include "asterfort/utmess.h"
!
integer :: list_func_acti(*)
integer :: iter_newt, nume_inst
type(NL_DS_AlgoPara), intent(in) :: ds_algopara
type(NL_DS_Measure), intent(inout) :: ds_measure
character(len=19) :: sddisc, sddyna, sdnume
character(len=19) :: list_load, matass
character(len=24) :: model, nume_dof, cara_elem
type(NL_DS_Material), intent(in) :: ds_material
type(NL_DS_Constitutive), intent(in) :: ds_constitutive
character(len=24) :: sderro
type(NL_DS_System), intent(in) :: ds_system
character(len=19) :: hval_veelem(*), hval_meelem(*)
character(len=19) :: hval_measse(*), hval_veasse(*)
character(len=19) :: hval_algo(*), hval_incr(*)
type(HHO_Field), intent(in) :: hhoField
type(NL_DS_Contact), intent(in) :: ds_contact
aster_logical :: lerrit
!
! --------------------------------------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME)
!
! MISE A JOUR DES EFFORTS APRES CALCUL DE LA CORRECTION DES CHAMPS
! DEPLACEMENTS/VITESSES ACCELERATIONS
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of model
! In  cara_elem        : name of elementary characteristics (field)
! In  ds_material      : datastructure for material parameters
! In  list_load        : name of datastructure for list of loads
! In  nume_dof         : name of numbering object (NUME_DDL)
! In  ds_material      : datastructure for material parameters
! In  ds_constitutive  : datastructure for constitutive laws management
! In  sddyna           : datastructure for dynamic
! IO  ds_measure       : datastructure for measure and statistics management
! In  list_func_acti   : list of active functionnalities
! In  ds_algopara      : datastructure for algorithm parameters
! In  ds_system        : datastructure for non-linear system management
! IN  ITERAT : NUMERO D'ITERATION DE NEWTON
! In  sddisc           : datastructure for time discretization
! In  nume_inst        : index of current time step
! IN  SDERRO : GESTION DES ERREURS
! In  ds_contact       : datastructure for contact management
! In  hval_incr        : hat-variable for incremental values fields
! In  hval_algo        : hat-variable for algorithms fields
! In  hhoField         : datastructure for HHO
! In  hval_veelem      : hat-variable for elementary vectors
! In  hval_veasse      : hat-variable for vectors (node fields)
! In  hval_measse      : hat-variable for matrix
! IN  SDNUME : SD NUMEROTATION
! OUT LERRIT : .TRUE. SI ERREUR PENDANT CORRECTION
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=24) :: mate, varc_refe
    aster_logical :: lcfint, lcrigi, lcdiri, lcbudi
    character(len=19) :: disp_curr, vite_curr, acce_curr, vect_lagr, rigid
    character(len=16) :: option
    aster_logical :: l_cont_disc, l_unil, leltc, l_hho
    aster_logical :: l_disp, l_vite, l_acce, l_dyna
    integer :: ldccvg, condcvg
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECANONLINE', ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'MECANONLINE13_63')
    endif
!
! --- INITIALISATIONS CODES RETOURS
!
    mate      = ds_material%mateco
    varc_refe = ds_material%varc_refe
    ldccvg    = -1
    condcvg   = -1
!
! --- FONCTIONNALITES ACTIVEES
!
    l_unil      = isfonc(list_func_acti,'LIAISON_UNILATER')
    l_cont_disc = isfonc(list_func_acti,'CONT_DISCRET')
    leltc       = isfonc(list_func_acti,'ELT_CONTACT')
    l_hho       = isfonc(list_func_acti,'HHO')
!
! - Get hat-variables
!
    call nmchex(hval_incr, 'VALINC', 'DEPPLU', disp_curr)
    call nmchex(hval_incr, 'VALINC', 'VITPLU', vite_curr)
    call nmchex(hval_incr, 'VALINC', 'ACCPLU', acce_curr)
!
! - Compute forces for second member at correction
!
    call nmforc_corr(list_func_acti,&
                     model         , cara_elem      , nume_dof,&
                     list_load     , sddyna         ,&
                     ds_material   , ds_constitutive,&
                     ds_measure    , &
                     sddisc        , nume_inst      ,&
                     hval_incr     , hval_algo      ,&
                     hval_veelem   , hval_veasse    ,&
                     hval_measse)
!
! --- CALCUL DU SECOND MEMBRE POUR CONTACT/XFEM
!
    if (leltc) then
        call nmfocc('CONVERGENC', model     , ds_material, nume_dof , list_func_acti,&
                    ds_contact  , ds_measure, hval_algo  , hval_incr, ds_constitutive)
    endif
!
! - Get option for update internal forces
!
    call nmchfi(ds_algopara, list_func_acti, sddyna   , ds_contact,&
                sddisc     , nume_inst     , iter_newt,&
                lcfint     , lcdiri        , lcbudi   , lcrigi    ,&
                option)
!
! - Compute internal forces / matrix rigidity
!
    if (lcfint) then
        if (lcrigi) then
            call nmrigi(model          , cara_elem,&
                        ds_material    , ds_constitutive,&
                        list_func_acti , iter_newt      , sddyna, ds_measure, ds_system,&
                        hval_incr      , hval_algo      , hhoField, &
                        option         , ldccvg)
        else
            call nmfint(model          , cara_elem      ,&
                        ds_material    , ds_constitutive,&
                        list_func_acti , iter_newt      , ds_measure, ds_system,&
                        hval_incr      , hval_algo      , hhoField, &
                        ldccvg         , sddyna)
        endif
!
        if(l_hho) then
            call nmchex(hval_measse, 'MEASSE', 'MERIGI', rigid)
            call hhoPrepMatrix(model, mate, ds_system%merigi, ds_system%vefint, rigid, hhoField,&
                               list_func_acti, hval_meelem, nume_dof, list_load, ds_algopara,&
                               ds_system, ds_measure, condcvg, &
                               l_cond = ASTER_TRUE, l_asse = ASTER_FALSE)
        end if
    endif
!
! - Get type of unknowns
!
    l_disp = ASTER_TRUE
    l_vite = ASTER_FALSE
    l_acce = ASTER_FALSE
    l_dyna  = ndynlo(sddyna,'DYNAMIQUE')
    if (l_dyna) then
        l_disp = ndynin(sddyna,'FORMUL_DYNAMIQUE') .eq. 1
        l_vite = ndynin(sddyna,'FORMUL_DYNAMIQUE') .eq. 2
        l_acce = ndynin(sddyna,'FORMUL_DYNAMIQUE') .eq. 3
    endif
!
! - Which unknowns for Lagrange multipliers ?
!
    if (l_disp) then
        vect_lagr = disp_curr
    else if (l_vite) then
        vect_lagr = disp_curr
    else if (l_acce) then
        vect_lagr = acce_curr
    else
        ASSERT(ASTER_FALSE)
    endif
!
! - No error => continue
!
    if (ldccvg .ne. 1) then
! ----- Compute vectors for DISCRETE contact
        if (l_cont_disc .or. l_unil) then
            call nmctcd(list_func_acti, ds_contact, nume_dof)
        endif
! ----- Assemble internal forces
        if (lcfint) then
            call nmaint(nume_dof, list_func_acti, sdnume, ds_system)
        endif
! ----- Compute force for Dirichlet boundary conditions (dualized) - BT.LAMBDA
        if (lcdiri) then
            call nonlinRForceCompute(model      , ds_material, cara_elem, list_load,&
                                     nume_dof   , ds_measure , vect_lagr,&
                                     hval_veelem, hval_veasse)
        endif
! ----- Compute Dirichlet boundary conditions - B.U
        call nonlinLoadDirichletCompute(list_load  , model      , nume_dof ,&
                                        ds_measure , matass     , disp_curr,&
                                        hval_veelem, hval_veasse)
    endif
!
! --- TRANSFORMATION DES CODES RETOURS EN EVENEMENTS
!
    call nmcret(sderro, 'LDC', ldccvg)
    call nmcret(sderro, 'HHO', condcvg)
!
! --- EVENEMENT ERREUR ACTIVE ?
!
    call nmltev(sderro, 'ERRI', 'NEWT', lerrit)
!
end subroutine
