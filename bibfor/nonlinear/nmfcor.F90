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
! aslint: disable=W1504
!
subroutine nmfcor(model          , nume_dof   , ds_material   , cara_elem  ,&
                  ds_constitutive, list_load  , list_func_acti, ds_algopara, nume_inst,&
                  iterat         , ds_measure , sddisc        , sddyna     , sdnume   ,&
                  sderro         , ds_contact , hval_incr     , hval_algo  ,&
                  hval_veelem    , hval_veasse, hval_meelem   , hval_measse, matass   ,&
                  lerrit)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/infdbg.h"
#include "asterfort/isfonc.h"
#include "asterfort/nmaint.h"
#include "asterfort/nonlinLoadDirichletCompute.h"
#include "asterfort/nmforc_corr.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmchfi.h"
#include "asterfort/nmcret.h"
#include "asterfort/nmctcd.h"
#include "asterfort/nmdiri.h"
#include "asterfort/nmfint.h"
#include "asterfort/nmfocc.h"
#include "asterfort/nmltev.h"
#include "asterfort/nmrigi.h"
#include "asterfort/nmtime.h"
!
integer :: list_func_acti(*)
integer :: iterat, nume_inst
type(NL_DS_AlgoPara), intent(in) :: ds_algopara
type(NL_DS_Measure), intent(inout) :: ds_measure
character(len=19) :: sddisc, sddyna, sdnume
character(len=19) :: list_load, matass
character(len=24) :: model, nume_dof, cara_elem
type(NL_DS_Material), intent(in) :: ds_material
type(NL_DS_Constitutive), intent(in) :: ds_constitutive
character(len=24) :: sderro
character(len=19) :: hval_meelem(*), hval_veelem(*)
character(len=19) :: hval_measse(*), hval_veasse(*)
character(len=19) :: hval_algo(*), hval_incr(*)
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
! IN  ITERAT : NUMERO D'ITERATION DE NEWTON
! In  sddisc           : datastructure for time discretization
! In  nume_inst        : index of current time step
! IN  SDERRO : GESTION DES ERREURS
! In  ds_contact       : datastructure for contact management
! In  hval_incr        : hat-variable for incremental values fields
! In  hval_algo        : hat-variable for algorithms fields
! In  hval_veelem      : hat-variable for elementary vectors
! In  hval_veasse      : hat-variable for vectors (node fields)
! In  hval_meelem      : hat-variable for elementary matrix
! In  hval_measse      : hat-variable for matrix
! IN  SDNUME : SD NUMEROTATION
! OUT LERRIT : .TRUE. SI ERREUR PENDANT CORRECTION
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: mate, varc_refe
    aster_logical :: lcfint, lcrigi, lcdiri, lcbudi
    character(len=19) :: vefint, vediri, cnfint, cndiri
    character(len=19) :: disp_curr, vite_curr, acce_curr
    character(len=16) :: option
    aster_logical :: l_cont_disc, l_unil, leltc
    integer :: ldccvg
    integer :: ifm, niv
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECA_NON_LINE', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> CORRECTION DES FORCES'
    endif
!
! --- INITIALISATIONS CODES RETOURS
!
    mate      = ds_material%field_mate
    varc_refe = ds_material%varc_refe
    ldccvg    = -1
!
! --- FONCTIONNALITES ACTIVEES
!
    l_unil      = isfonc(list_func_acti,'LIAISON_UNILATER')
    l_cont_disc = isfonc(list_func_acti,'CONT_DISCRET')
    leltc       = isfonc(list_func_acti,'ELT_CONTACT')
!
! - Get hat-variables
!
    call nmchex(hval_incr, 'VALINC', 'DEPPLU', disp_curr)
    call nmchex(hval_incr, 'VALINC', 'VITPLU', vite_curr)
    call nmchex(hval_incr, 'VALINC', 'ACCPLU', acce_curr)
    call nmchex(hval_veelem, 'VEELEM', 'CNFINT', vefint)
    call nmchex(hval_veasse, 'VEASSE', 'CNFINT', cnfint)
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
                sddisc     , nume_inst     , iterat,&
                lcfint     , lcdiri        , lcbudi   , lcrigi    ,&
                option)
!
! - Compute internal forces / matrix rigidity
!
    if (lcfint) then
        if (lcrigi) then
            call nmrigi(model    , mate  , cara_elem, ds_constitutive, sddyna,&
                        ds_measure, list_func_acti, iterat, hval_incr, hval_algo,&
                        varc_refe, hval_meelem, hval_veelem, option         , ldccvg)
        else
            call nmfint(model, mate  , cara_elem, varc_refe , ds_constitutive,&
                        list_func_acti, iterat, sddyna, ds_measure, hval_incr         ,&
                        hval_algo, ldccvg, vefint)
        endif
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
            call nmaint(nume_dof, list_func_acti, sdnume,&
                        vefint  , cnfint)
        endif
! ----- Launch timer
        call nmtime(ds_measure, 'Init', '2nd_Member')
        call nmtime(ds_measure, 'Launch', '2nd_Member')
! ----- Compute force for Dirichlet boundary conditions (dualized) - BT.LAMBDA
        if (lcdiri) then
            call nmchex(hval_veelem, 'VEELEM', 'CNDIRI', vediri)
            call nmchex(hval_veasse, 'VEASSE', 'CNDIRI', cndiri)
            call nmdiri(model    , ds_material, cara_elem, list_load,&
                        disp_curr, vediri     , nume_dof , cndiri   ,&
                        sddyna   , vite_curr  , acce_curr)
        endif
! ----- End timer
        call nmtime(ds_measure, 'Stop', '2nd_Member')
! ----- Compute Dirichlet boundary conditions - B.U
        call nonlinLoadDirichletCompute(list_load  , model      , nume_dof ,&
                                        ds_measure , matass     , disp_curr,&
                                        hval_veelem, hval_veasse)
    endif
!
! --- TRANSFORMATION DES CODES RETOURS EN EVENEMENTS
!
    call nmcret(sderro, 'LDC', ldccvg)
!
! --- EVENEMENT ERREUR ACTIVE ?
!
    call nmltev(sderro, 'ERRI', 'NEWT', lerrit)
!
end subroutine
