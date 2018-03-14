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
subroutine nmforc_step(list_func_acti,&
                       model         , cara_elem      , nume_dof,&
                       list_load     , sddyna         ,&
                       ds_material   , ds_constitutive,&
                       ds_measure    , ds_inout       ,&
                       sddisc        , nume_inst      ,&
                       hval_incr     , hval_algo      ,&
                       hval_veelem   , hval_veasse)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infdbg.h"
#include "asterfort/utmess.h"
#include "asterfort/nonlinLoadCompute.h"
#include "asterfort/nonlinLoadDynaCompute.h"
#include "asterfort/nonlinNForceCompute.h"
#include "asterfort/nmvcpr.h"
#include "asterfort/diinst.h"
#include "asterfort/ndynlo.h"
#include "asterfort/isfonc.h"
!
integer, intent(in) :: list_func_acti(*)
character(len=24), intent(in) :: model, cara_elem, nume_dof
character(len=19), intent(in) :: list_load, sddyna
type(NL_DS_Material), intent(in) :: ds_material
type(NL_DS_Constitutive), intent(in) :: ds_constitutive
type(NL_DS_Measure), intent(inout) :: ds_measure
type(NL_DS_InOut), intent(in) :: ds_inout
character(len=19), intent(in) :: sddisc
integer, intent(in) :: nume_inst
character(len=19), intent(in) :: hval_incr(*), hval_algo(*)
character(len=19), intent(in) :: hval_veelem(*), hval_veasse(*)
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Algorithm
!
! Compute forces for second member when constant in time step
!
! --------------------------------------------------------------------------------------------------
!
! In  list_func_acti   : list of active functionnalities
! In  model            : name of model
! In  cara_elem        : name of elementary characteristics (field)
! In  nume_dof         : name of numbering object (NUME_DDL)
! In  list_load        : name of datastructure for list of loads
! In  sddyna           : datastructure for dynamic
! In  ds_material      : datastructure for material parameters
! In  ds_constitutive  : datastructure for constitutive laws management
! IO  ds_measure       : datastructure for measure and statistics management
! In  ds_inout         : datastructure for input/output management
! In  sddisc           : datastructure for time discretization
! In  nume_inst        : index of current time step
! In  hval_incr        : hat-variable for incremental values fields
! In  hval_algo        : hat-variable for algorithms fields
! In  hval_veelem      : hat-variable for elementary vectors
! In  hval_veasse      : hat-variable for vectors (node fields)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    real(kind=8) :: time_prev, time_curr
    aster_logical :: l_dyna, l_expl, l_implex
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECANONLINE', ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'MECANONLINE11_13')
    endif
!
! - Get time
!
    ASSERT(nume_inst .gt. 0)
    time_prev = diinst(sddisc,nume_inst-1)
    time_curr = diinst(sddisc,nume_inst)
!
! - Active functionnalities
!
    l_dyna       = ndynlo(sddyna,'DYNAMIQUE')
    l_expl       = ndynlo(sddyna,'EXPLICITE')
    l_implex     = isfonc(list_func_acti,'IMPLEX')
!
! - Compute CHAR_MECA_*_R for PREDICTOR
!
    call nmvcpr(model    , ds_material%field_mate,&
                cara_elem, ds_material%varc_refe , ds_constitutive%compor, &
                hval_incr, nume_dof_ = nume_dof, base_ = 'V',&
                vect_elem_prev_ = '&&VEVCOM',&
                vect_elem_curr_ = '&&VEVCOP',&
                cnvcpr_ = ds_material%fvarc_pred)
!
! - Compute loads
!
    call nonlinLoadCompute('FIXE'     , list_load      ,&
                           model      , cara_elem      , nume_dof  , list_func_acti,&
                           ds_material, ds_constitutive, ds_measure,&
                           time_prev  , time_curr      ,&
                           hval_incr  , hval_algo      ,&
                           hval_veelem, hval_veasse)
!
! - Compute loads (for dynamic)
!
    if (l_dyna) then
        call nonlinLoadDynaCompute('FIXE'     , sddyna     ,&
                                   model      , nume_dof   ,&
                                   ds_material, ds_measure , ds_inout,&
                                   time_prev  , time_curr  ,&
                                   hval_veelem, hval_veasse)
    endif
!
! - Compute nodal force BT . SIGMA (No integration of behaviour)
!
    if (.not.(l_expl.or.l_implex)) then
        call nonlinNForceCompute(model      , cara_elem      , nume_dof  , list_func_acti,&
                                 ds_material, ds_constitutive, ds_measure,&
                                 time_prev  , time_curr      ,&
                                 hval_incr  , hval_algo      ,&
                                 hval_veelem, hval_veasse)
    endif
!
end subroutine
