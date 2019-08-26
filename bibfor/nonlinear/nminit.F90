! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
subroutine nminit(mesh       , model         , mate         , cara_elem      , list_load ,&
                  numedd     , numfix        , ds_algopara  , ds_constitutive, maprec    ,&
                  solver     , numins        , sddisc       , sdnume         , sdcrit    ,&
                  ds_material, list_func_acti, sdpilo       , sddyna         , ds_print  ,&
                  sd_suiv    , sd_obsv       , sderro       , ds_posttimestep, ds_inout  ,&
                  ds_energy  , ds_conv       , ds_errorindic, valinc         , solalg    ,&
                  measse     , veelem        , meelem       , veasse         , ds_contact,&
                  ds_measure , ds_algorom    , ds_system)
!
use NonLin_Datastructure_type
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/accel0.h"
#include "asterfort/assert.h"
#include "asterfort/cfmxsd.h"
#include "asterfort/cucrsd.h"
#include "asterfort/diinit.h"
#include "asterfort/diinst.h"
#include "asterfort/exfonc.h"
#include "asterfort/isfonc.h"
#include "asterfort/jeveuo.h"
#include "asterfort/liscpy.h"
#include "asterfort/lobs.h"
#include "asterfort/ndynlo.h"
#include "asterfort/nmchap.h"
#include "asterfort/nmforc_acci.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmcrch.h"
#include "asterfort/nmcrcv.h"
#include "asterfort/nmcrob.h"
#include "asterfort/nmcrdd.h"
#include "asterfort/nmcrti.h"
#include "asterfort/nmdidi.h"
#include "asterfort/nmdoct.h"
#include "asterfort/nmdoet.h"
#include "asterfort/nmdopi.h"
#include "asterfort/nmetcr.h"
#include "asterfort/nmetpl.h"
#include "asterfort/nmexso.h"
#include "asterfort/nmfonc.h"
#include "asterfort/nmihht.h"
#include "asterfort/nonlinDSAlgoParaInit.h"
#include "asterfort/nonlinDSContactInit.h"
#include "asterfort/nonlinDSConvergenceInit.h"
#include "asterfort/nonlinDSEnergyInit.h"
#include "asterfort/nonlinDSPrintInit.h"
#include "asterfort/romAlgoNLInit.h"
#include "asterfort/nonlinDSConstitutiveInit.h"
#include "asterfort/nonlinDSPostTimeStepInit.h"
#include "asterfort/nonlinDSInOutInit.h"
#include "asterfort/nonlinSystemInit.h"
#include "asterfort/nmrefe.h"
#include "asterfort/nminma.h"
#include "asterfort/nminmc.h"
#include "asterfort/nmlssv.h"
#include "asterfort/nmnoli.h"
#include "asterfort/nmnume.h"
#include "asterfort/nmobse.h"
#include "asterfort/nmobsw.h"
#include "asterfort/nmpro2.h"
#include "asterfort/nmrini.h"
#include "asterfort/nonlinDSMaterialInit.h"
#include "asterfort/utmess.h"
#include "asterfort/infdbg.h"
#include "asterfort/nonlinDSPrintSepLine.h"
#include "asterfort/nonlinDSDynamicInit.h"
#include "asterfort/nonlinDSErrorIndicInit.h"
!
character(len=8), intent(in) :: mesh
character(len=24), intent(in) :: model
character(len=24), intent(in) :: mate
character(len=24), intent(in) :: cara_elem
character(len=19), intent(in) :: list_load
character(len=24) :: numedd
character(len=24) :: numfix
type(NL_DS_AlgoPara), intent(inout) :: ds_algopara
type(NL_DS_Constitutive), intent(inout) :: ds_constitutive
character(len=19) :: maprec
character(len=19), intent(in) :: solver
integer :: numins
character(len=19) :: sddisc
character(len=19) :: sdnume
character(len=19) :: sdcrit
type(NL_DS_Material), intent(inout) :: ds_material
integer, intent(inout) :: list_func_acti(*)
character(len=19) :: sdpilo
character(len=19) :: sddyna
type(NL_DS_Print), intent(inout) :: ds_print
character(len=24), intent(out) :: sd_suiv
character(len=19), intent(out) :: sd_obsv
character(len=24) :: sderro
type(NL_DS_PostTimeStep), intent(inout) :: ds_posttimestep
type(NL_DS_InOut), intent(inout) :: ds_inout
type(NL_DS_Energy), intent(inout) :: ds_energy
type(NL_DS_Conv), intent(inout) :: ds_conv
type(NL_DS_ErrorIndic), intent(inout) :: ds_errorindic
character(len=19) :: valinc(*)
character(len=19) :: solalg(*)
character(len=19) :: measse(*)
character(len=19) :: veelem(*)
character(len=19) :: meelem(*)
character(len=19) :: veasse(*)
type(NL_DS_Contact), intent(inout) :: ds_contact
type(NL_DS_Measure), intent(inout) :: ds_measure
type(ROM_DS_AlgoPara), intent(inout) :: ds_algorom
type(NL_DS_System), intent(inout) :: ds_system
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Initializations
!
! Initializations of datastructures
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  model            : name of model
! In  mate             : name of material characteristics (field)
! In  cara_elem        : name of elementary characteristics (field)
! In  list_load        : name of datastructure for list of loads
! IO  ds_material      : datastructure for material parameters
! IO  ds_algopara      : datastructure for algorithm parameters
! IO  ds_constitutive  : datastructure for constitutive laws management
! IO  ds_posttimestep  : datastructure for post-treatment at each time step
! In  solver           : name of datastructure for solver
! IO  ds_print         : datastructure for printing parameters
! Out sd_suiv          : datastructure for dof monitoring parameters
! Out sd_obsv          : datastructure for observation parameters
! IO  ds_inout         : datastructure for input/output management
! IO  ds_energy        : datastructure for energy management
! IO  ds_inout         : datastructure for input/output management
! IO  ds_errorindic    : datastructure for error indicator
! Out sd_obsv          : datastructure for observation parameters
! Out sd_suiv          : datastructure for dof monitoring parameters
! IO  ds_print         : datastructure for printing parameters
! IO  ds_conv          : datastructure for convergence management
! IO  ds_algopara      : datastructure for algorithm parameters
! IO  ds_contact       : datastructure for contact management
! IO  ds_measure       : datastructure for measure and statistics management
! IO  ds_algorom       : datastructure for ROM parameters
! IO  ds_system        : datastructure for non-linear system management
! IO  list_func_acti   : list of active functionnalities
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    real(kind=8) :: instin
    character(len=19) :: varc_prev, disp_prev, strx_prev, varc_curr, disp_curr, strx_curr
    aster_logical :: lacc0, lpilo, lmpas, lsstf, lviss, lrefe, ldidi, l_obsv, l_ener, l_dyna
    aster_logical :: l_erre_thm
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECANONLINE',ifm, niv)
    if (niv .ge. 2) then
        call nonlinDSPrintSepLine()
        call utmess('I', 'MECANONLINE13_1')
    endif
!
! - Initialisations
!
    lacc0 = ASTER_FALSE
!
! - Initializations for contact parameters
!
    call nonlinDSContactInit(mesh, model, ds_contact)
!
! - Initializations for constitutive laws
!
    call nonlinDSConstitutiveInit(model, cara_elem, ds_constitutive)
!
! - Initializations for post-treatment at each time step
!
    call nonlinDSPostTimeStepInit(ds_inout%result, model          ,&
                                  ds_algopara    , ds_constitutive, ds_posttimestep)
!
! - Prepare list of loads (and late elements) for contact
!
    call nmdoct(list_load, ds_contact)
!
! - Create information about numbering
!
    call nmnume(model     , mesh  , ds_inout%result, ds_constitutive%compor, list_load,&
                ds_contact, numedd, sdnume)
!
! - Create "hat" variables
!
    call nmchap(valinc, solalg, meelem, veelem, veasse, measse)
!
! - Prepare active functionnalities information
!
    call nmfonc(ds_conv       , ds_algopara    , solver   , model        , ds_contact     ,&
                list_load     , sdnume         , sddyna   , ds_errorindic, mate           ,&
                ds_inout      , ds_constitutive, ds_energy, ds_algorom   , ds_posttimestep,&
                list_func_acti)
!
! - Check compatibility of some functionnalities
!
    call exfonc(list_func_acti, ds_algopara, solver, ds_contact, sddyna,& 
                mate          , model)
    lpilo      = isfonc(list_func_acti,'PILOTAGE' )
    lmpas      = ndynlo(sddyna,'MULTI_PAS' )
    lsstf      = isfonc(list_func_acti,'SOUS_STRUC')
    l_erre_thm = isfonc(list_func_acti,'ERRE_TEMPS_THM')
    lviss      = ndynlo(sddyna,'VECT_ISS' )
    lrefe      = isfonc(list_func_acti,'RESI_REFE')
    ldidi      = isfonc(list_func_acti,'DIDI')
    l_ener     = isfonc(list_func_acti,'ENERGIE')
    l_dyna     = ndynlo(sddyna,'DYNAMIQUE')
!
! - Initialization for reduced method
!
    if (ds_algorom%l_rom) then
        call romAlgoNLInit('MECA', model, mesh, numedd, ds_inout%result, ds_algorom)
    endif
!
! - Prepare contact solving datastructure
!
    if (ds_contact%l_meca_cont) then
        call cfmxsd(mesh, model, numedd, list_func_acti, sddyna, ds_contact)
    endif
!
! --- CREATION DE LA STRUCTURE DE LIAISON_UNILATERALE
!
    if (ds_contact%l_meca_unil) then
        call cucrsd(mesh, numedd, ds_contact)
    endif
!
! - Initializations for measure and statistic management
!
    call nmcrti(list_func_acti, ds_inout%result, ds_contact, ds_measure)
!
! - Initializations for algorithm parameters
!
    call nonlinDSAlgoParaInit(list_func_acti, ds_algopara, ds_contact)
!
! - Initializations for convergence management
!
    call nonlinDSConvergenceInit(ds_conv, list_func_acti, ds_contact)
!
! - Initializations for energy management
!
    if (l_ener) then
        call nonlinDSEnergyInit(ds_inout%result, ds_energy)
    endif
!
! - Initializations for input/output management
!
    call nonlinDSInOutInit('MECA', ds_inout)
!
! - Initializations for error indicator management
!
    if (l_erre_thm) then
        call nonlinDSErrorIndicInit(model, ds_constitutive, ds_errorindic)
    endif
!
! --- CREATION DES VECTEURS D'INCONNUS
!
    call nmcrch(numedd, list_func_acti, sddyna, ds_contact, valinc,&
                solalg, veasse)
!
! - Initializations for dynamic
!
    call nonlinDSDynamicInit(valinc, sddyna)
!
! --- CONSTRUCTION DU CHAM_NO ASSOCIE AU PILOTAGE
!
    if (lpilo) then
        call nmdopi(model, numedd, ds_algopara, sdpilo)
    endif
!
! --- DUPLICATION NUME_DDL POUR CREER UN DUME_DDL FIXE
!
    call nmpro2(list_func_acti, numedd, numfix)
!
! - Create input/output datastructure
!
    call nmetcr(ds_inout  , model    , ds_constitutive%compor, list_func_acti, sddyna,&
                ds_contact, cara_elem, list_load)
!
! - Read initial state
!
    call nmdoet(model , ds_constitutive%compor, list_func_acti, numedd, sdpilo,&
                sddyna, ds_errorindic         , solalg        , lacc0 , ds_inout)
!
! - Create time discretization and storing datastructures
!
    call diinit(mesh          , model , ds_inout, mate       , cara_elem,&
                list_func_acti, sddyna, ds_conv , ds_algopara, solver,&
                ds_contact    , sddisc)
!
! - Initial time
!
    numins = 0
    instin = diinst(sddisc,numins)
!
! - Initializations for material parameters management
!
    call nonlinDSMaterialInit(model      , mate     , cara_elem,&
                              ds_constitutive%compor, valinc,&
                              numedd     , instin   , &
                              ds_material)
!
! - Initializations for non-linear system
!
    call nonlinSystemInit(list_func_acti, sddyna, numedd, ds_system)
!
! --- PRE-CALCUL DES MATR_ELEM CONSTANTES AU COURS DU CALCUL
!
    call nminmc(list_func_acti, list_load  , sddyna   , model , ds_constitutive,&
                numedd        , numfix     , solalg   ,&
                valinc        , ds_material, cara_elem, sddisc, ds_measure     ,&
                meelem        , measse     , ds_system)
!
! - Compute reference vector for RESI_REFE_RELA
!
    if (lrefe) then
        call nmrefe(model  , ds_constitutive%compor, mate  , cara_elem, numedd,&
                    ds_conv, valinc                , veelem, veasse)
    endif
!
! - Compute vector for DIDI loads
!
    if (ldidi) then
        call nmdidi(ds_inout, model , list_load, numedd, valinc,&
                    veelem  , veasse)
    endif 
!
! --- CREATION DE LA SD POUR ARCHIVAGE DES INFORMATIONS DE CONVERGENCE
!
    call nmcrcv(sdcrit)
!
! --- INITIALISATION CALCUL PAR SOUS-STRUCTURATION
!
    if (lsstf) then
        call nmlssv(list_load)
    endif
!
! --- CREATION DE LA SD EXCIT_SOL
!
    if (lviss) then
        call nmexso(mesh, ds_inout, sddyna, numedd)
    endif
!
! --- CALCUL DE L'ACCELERATION INITIALE
!
    if (lacc0) then
! ----- Compute forces for second member for initial acceleration
        call nmforc_acci(list_func_acti,&
                         model         , cara_elem      , numedd   ,&
                         list_load     , sddyna         ,&
                         ds_material   , ds_constitutive, ds_system,&
                         ds_measure    , ds_inout       ,&
                         sddisc        , numins         ,&
                         valinc        , solalg         ,&
                         veelem        , veasse         ,&
                         measse)
! ----- Compute initial acceleration
        call accel0(model     , numedd   , list_func_acti, list_load,&
                    ds_contact, maprec   , solver        , valinc   , sddyna,&
                    ds_measure, ds_system, meelem        , measse   ,&
                    veelem    , veasse   , solalg)
    endif
!
! - Extract variables
!
    call nmchex(valinc, 'VALINC', 'DEPMOI', disp_prev)
    call nmchex(valinc, 'VALINC', 'STRMOI', strx_prev)
    call nmchex(valinc, 'VALINC', 'COMMOI', varc_prev)
    call nmchex(valinc, 'VALINC', 'DEPPLU', disp_curr)
    call nmchex(valinc, 'VALINC', 'STRPLU', strx_curr)
    call nmchex(valinc, 'VALINC', 'COMPLU', varc_curr)
!
! - Create observation datastructure
!
    call nmcrob(mesh       , model          , sddisc   , ds_inout , cara_elem,&
                ds_material, ds_constitutive, disp_prev, strx_prev, varc_prev,&
                instin     , sd_obsv  )
!
! - Create dof monitoring datastructure
!
    call nmcrdd(mesh           , model    , ds_inout , cara_elem, ds_material,&
                ds_constitutive, disp_prev, strx_prev, varc_prev, instin     ,&
                sd_suiv)
!
! - Initializations for printing
!
    call nonlinDSPrintInit(ds_print, sd_suiv)
!
! --- PRE-CALCUL DES MATR_ASSE CONSTANTES AU COURS DU CALCUL
!
    call nminma(list_load, sddyna, numedd,&
                numfix   , meelem, measse)
!
! - Prepare storing
!
    call nmnoli(sddisc        , sderro, ds_print   , sdcrit     ,&
                list_func_acti, sddyna, model      , ds_material,&
                cara_elem     , sdpilo, ds_measure , ds_energy  , ds_inout,&
                ds_errorindic)
!
! - Make initial observation
!
    l_obsv = ASTER_FALSE
    call lobs(sd_obsv, numins, instin, l_obsv)
    if (l_obsv) then
        call nmobse(mesh     , sd_obsv  , instin,&
                    cara_elem, model    , ds_material, ds_constitutive, disp_curr,&
                    strx_curr, varc_curr)
        if (numins.eq.0) then
            call nmobsw(sd_obsv, ds_inout)
        endif
    endif
!
! - Update name of fields
!
    call nmetpl(ds_inout, sd_suiv, sd_obsv)
!
! --- CALCUL DU SECOND MEMBRE INITIAL POUR MULTI-PAS
!
    if (lmpas) then
        call nmihht(model    , numedd   , ds_material   , ds_constitutive,&
                    cara_elem, list_load, list_func_acti, ds_measure     ,&
                    sddyna   , sdnume   , valinc        , &
                    sddisc   , solalg   , measse        , ds_inout)
    endif
!
! - Reset times and counters
!
    call nmrini(ds_measure, 'T')
!
end subroutine
