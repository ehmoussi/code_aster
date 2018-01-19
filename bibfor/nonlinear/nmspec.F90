! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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
subroutine nmspec(model          , mate         , cara_elem , list_load  , list_func_acti,& 
                  nume_dof       , nume_dof_inva,&
                  ds_constitutive, varc_refe    ,&
                  sddisc         , nume_inst    ,&
                  sddyna         , sderro       , ds_contact, ds_algopara,&
                  ds_measure     , &
                  hval_incr      , hval_algo    ,&
                  hval_meelem    , hval_measse  ,&
                  hval_veelem    ,&
                  ds_posttimestep)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/diinst.h"
#include "asterfort/isfonc.h"
#include "asterfort/selectListGet.h"
#include "asterfort/nmflam.h"
#include "asterfort/utmess.h"
!
character(len=24), intent(in) :: model, mate, cara_elem
character(len=19), intent(in) :: list_load
integer, intent(in) :: list_func_acti(*)
character(len=24), intent(in) :: nume_dof, nume_dof_inva
character(len=24), intent(in) :: varc_refe
type(NL_DS_Constitutive), intent(in) :: ds_constitutive
character(len=19), intent(in) :: sddisc
integer, intent(in) :: nume_inst
character(len=19), intent(in) :: sddyna
character(len=24), intent(in) :: sderro
type(NL_DS_Contact), intent(in) :: ds_contact
type(NL_DS_AlgoPara), intent(in) :: ds_algopara
type(NL_DS_Measure), intent(inout) :: ds_measure
character(len=19), intent(in) :: hval_incr(*), hval_algo(*)
character(len=19), intent(in) :: hval_veelem(*), hval_meelem(*), hval_measse(*)
type(NL_DS_PostTimeStep), intent(inout) :: ds_posttimestep
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Initializations
!
! Spectral analysis
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of model
! In  mate             : name of material characteristics (field)
! In  cara_elem        : name of elementary characteristics (field)
! In  list_load        : datastructure for list of loads
! In  list_func_acti   : list of active functionnalities
! In  nume_dof         : name of numbering (NUME_DDL)
! In  nume_dof_inva    : name of reference numbering (invariant)
! In  ds_constitutive  : datastructure for constitutive laws management
! In  varc_refe        : name of reference external state variables
! In  sddisc           : datastructure for time discretization
! In  nume_inst        : index of current time step
! In  sddyna           : datastructure for dynamic
! In  sderro           : datastructure for error management (events)
! In  ds_contact       : datastructure for contact management
! In  ds_algopara      : datastructure for algorithm parameters
! IO  ds_measure       : datastructure for measure and statistics management
! In  hval_incr        : hat-variable for incremental values fields
! In  hval_algo        : hat-variable for algorithms fields
! In  hval_veelem      : hat-variable for elementary vectors
! In  hval_meelem      : hat-variable for elementary matrix
! In  hval_measse      : hat-variable for matrix
! IO  ds_posttimestep  : datastructure for post-treatment at each time step
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: l_mode_vibr, l_crit_stab, l_select
    real(kind=8) :: inst
    character(len=16) :: option
!
! --------------------------------------------------------------------------------------------------
!
    inst     = diinst(sddisc, nume_inst)
    l_select = ASTER_FALSE
    option   = ' '
!
! - Active functionnalites
!
    l_mode_vibr = isfonc(list_func_acti,'MODE_VIBR')
    l_crit_stab = isfonc(list_func_acti,'CRIT_STAB')
!
! - Compute stability criterion
!
    if (l_crit_stab) then
        call selectListGet(ds_posttimestep%crit_stab%selector, nume_inst, inst, l_select)
        if (l_select) then
            option = ds_posttimestep%crit_stab%option
! --------- Print
            if (option .eq. 'FLAMBSTA') then
                call utmess('I', 'MECANONLINE6_2')
            else if (option.eq.'FLAMBDYN') then
                call utmess('I', 'MECANONLINE6_2')
            else
                ASSERT(ASTER_FALSE)
            endif
! --------- Compute
            call nmflam(option         ,&
                        model          , mate         , cara_elem , list_load  , list_func_acti,&
                        nume_dof       , nume_dof_inva,&
                        ds_constitutive, varc_refe    ,&
                        sddisc         , nume_inst    ,& 
                        sddyna         , sderro       , ds_contact, ds_algopara,& 
                        ds_measure     ,&
                        hval_incr      , hval_algo    ,&
                        hval_meelem    , hval_measse  ,&
                        hval_veelem    ,&
                        ds_posttimestep)
        endif
    endif
!
! - Compute vibration modes
!
    if (l_mode_vibr) then
        call selectListGet(ds_posttimestep%mode_vibr%selector, nume_inst, inst, l_select)
        if (l_select) then
            option = ds_posttimestep%mode_vibr%option
! --------- Print
            call utmess('I', 'MECANONLINE6_3')
! --------- Compute
            call nmflam(option         ,&
                        model          , mate         , cara_elem , list_load  , list_func_acti,&
                        nume_dof       , nume_dof_inva,&
                        ds_constitutive, varc_refe    ,&
                        sddisc         , nume_inst    ,& 
                        sddyna         , sderro       , ds_contact, ds_algopara,& 
                        ds_measure     ,&
                        hval_incr      , hval_algo    ,&
                        hval_meelem    , hval_measse  ,&
                        hval_veelem    ,&
                        ds_posttimestep)
        endif
    endif
!
end subroutine
