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
subroutine nmpost(model          , mesh           , cara_elem      , list_load,&
                  numedof        , numfix         , ds_system      ,&
                  ds_constitutive, ds_material   ,&
                  ds_contact     , ds_algopara    , list_func_acti ,&
                  ds_measure     , sddisc         , nume_inst      , eta      ,&
                  sd_obsv        , sderro         , sddyna         ,&
                  hval_incr      , hval_algo      ,&
                  hval_meelem    , hval_measse    , hval_veasse    ,&
                  ds_energy      , ds_errorindic  ,&
                  ds_posttimestep)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/cfmxpo.h"
#include "asterfort/isfonc.h"
#include "asterfort/lobs.h"
#include "asterfort/diinst.h"
#include "asterfort/nmener.h"
#include "asterfort/nmetca.h"
#include "asterfort/nmleeb.h"
#include "asterfort/nmobse.h"
#include "asterfort/nmspec.h"
#include "asterfort/nmtime.h"
#include "asterfort/nmrinc.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmrest_ecro.h"
!
character(len=24), intent(in) :: model
character(len=8), intent(in) :: mesh
character(len=24), intent(in) :: cara_elem
character(len=19), intent(in) :: list_load
character(len=24), intent(in) :: numedof, numfix
type(NL_DS_System), intent(in) :: ds_system
type(NL_DS_Constitutive), intent(in) :: ds_constitutive
type(NL_DS_Material), intent(in) :: ds_material
type(NL_DS_Contact), intent(inout) :: ds_contact
type(NL_DS_AlgoPara), intent(in) :: ds_algopara
integer, intent(in) :: list_func_acti(*)
type(NL_DS_Measure), intent(inout) :: ds_measure
character(len=19), intent(in) :: sddisc
integer, intent(in) :: nume_inst
real(kind=8), intent(in) :: eta
character(len=19), intent(in) :: sd_obsv
character(len=24), intent(in) :: sderro
character(len=19), intent(in) :: sddyna
character(len=19), intent(in) :: hval_incr(*), hval_algo(*)
character(len=19), intent(in) :: hval_meelem(*), hval_measse(*)
character(len=19), intent(in) :: hval_veasse(*)
type(NL_DS_Energy), intent(inout) :: ds_energy
type(NL_DS_ErrorIndic), intent(inout) :: ds_errorindic
type(NL_DS_PostTimeStep), intent(inout) :: ds_posttimestep
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Algorithm
!
! Post-treatment at each time step
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of model
! In  mesh             : name of mesh
! In  cara_elem        : name of elementary characteristics (field)
! In  list_load        : name of datastructure for list of loads
! In  numedof          : NUME_DDL
! IN  NUMFIX : NUME_DDL (FIXE AU COURS DU CALCUL)
! In  ds_system        : datastructure for non-linear system management
! In  ds_constitutive  : datastructure for constitutive laws management
! In  ds_material      : datastructure for material parameters
! IO  ds_contact       : datastructure for contact management
! In  ds_algopara      : datastructure for algorithm parameters
! In  list_func_acti   : list of active functionnalities
! IO  ds_measure       : datastructure for measure and statistics management
! In  sddisc           : datastructure for time discretization
! In  nume_inst        : index of current time step
! In  sd_obsv          : datastructure for observation parameters
! In  sderro           : datastructure for error management (events)
! In  sddyna           : datastructure for dynamic
! In  hval_incr        : hat-variable for incremental values fields
! In  hval_algo        : hat-variable for algorithms fields
! In  hval_meelem      : hat-variable for elementary matrix
! In  hval_measse      : hat-variable for matrix
! In  hval_veasse      : hat-variable for vectors (node fields)
! IO  ds_energy        : datastructure for energy management
! IO  ds_errorindic    : datastructure for error indicator
! IO  ds_posttimestep  : datastructure for post-treatment at each time step
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: l_mode_vibr, l_crit_stab, lerrt, lcont, lener, l_post_incr, l_obsv
    character(len=4) :: etfixe
    real(kind=8) :: time
    character(len=19) :: varc_curr, disp_curr, strx_curr
!
! --------------------------------------------------------------------------------------------------
!
    lcont       = isfonc(list_func_acti,'CONTACT')
    lerrt       = isfonc(list_func_acti,'ERRE_TEMPS_THM')
    l_mode_vibr = isfonc(list_func_acti,'MODE_VIBR')
    l_crit_stab = isfonc(list_func_acti,'CRIT_STAB')
    lener       = isfonc(list_func_acti,'ENERGIE')
    l_post_incr = isfonc(list_func_acti,'POST_INCR')
!
! - Extract variables
!    
    call nmchex(hval_incr, 'VALINC', 'DEPPLU', disp_curr)
    call nmchex(hval_incr, 'VALINC', 'STRPLU', strx_curr)
    call nmchex(hval_incr, 'VALINC', 'COMPLU', varc_curr)
!
! - Observation ?
!
    l_obsv = ASTER_FALSE
    time   = diinst(sddisc, nume_inst)
    call lobs(sd_obsv, nume_inst, time, l_obsv)
!
! - State of time loop
!
    call nmleeb(sderro, 'FIXE', etfixe)
!
! - Post-treatment ?
!
    if (etfixe .eq. 'CONV') then
! ----- Launch timer for post-treatment
        call nmtime(ds_measure, 'Init'  , 'Post')
        call nmtime(ds_measure, 'Launch', 'Post')
! ----- Evaluate THM error (SM)
        if (lerrt) then
            call nmetca(model , mesh     , ds_material%field_mate, hval_incr,&
                        sddisc, nume_inst, ds_errorindic)
        endif
! ----- Post-treatment for contact
        if (lcont) then
            call cfmxpo(mesh      , model    , ds_contact, nume_inst, sddisc,&
                        ds_measure, hval_algo, hval_incr )
        endif
! ----- Spectral analysis (MODE_VIBR/CRIT_STAB)
        if (l_mode_vibr .or. l_crit_stab) then
            call nmspec(model          , ds_material   , cara_elem  ,&
                        list_load      , list_func_acti,& 
                        numedof        , numfix        , ds_system  ,&
                        ds_constitutive, &
                        sddisc         , nume_inst     ,&
                        sddyna         , sderro        , ds_algopara,&
                        ds_measure     ,&
                        hval_incr      , hval_algo     ,&
                        hval_meelem    , hval_measse   ,&
                        ds_posttimestep)
        endif
! ----- CALCUL DES ENERGIES
        if (lener) then
            call nmener(hval_incr      , hval_veasse   , hval_measse, sddyna     , eta      ,&
                        ds_energy      , list_func_acti, numedof    , numfix     ,&
                        hval_meelem    , nume_inst     , model      , ds_material, cara_elem,&
                        ds_constitutive, ds_measure    , sddisc     , hval_algo  ,&
                        ds_contact     , ds_system)
        endif
! ----- Post-treatment for behavior laws.
        if (l_post_incr) then
            call nmrest_ecro(model, ds_material%field_mate, ds_constitutive, hval_incr)
        endif
! ----- Make observation
        if (l_obsv) then
            call nmobse(mesh     , sd_obsv  , time,&
                        cara_elem, model    , ds_material, ds_constitutive, disp_curr,&
                        strx_curr, varc_curr)
        endif
! ----- End of timer for post-treatment
        call nmtime(ds_measure, 'Stop', 'Post')
        call nmrinc(ds_measure, 'Post')
    endif
!
end subroutine
