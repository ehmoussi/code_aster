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
!
subroutine nonlinIntForce(phaseType     ,&
                          model         , cara_elem      ,&
                          list_func_acti, iter_newt      , sdnume,&
                          ds_material   , ds_constitutive,&
                          ds_system     , ds_measure     ,&
                          hval_incr     , hval_algo      ,&
                          ldccvg        ,&
                          hhoField_     , sddyna_        ,&
                          time_prev_    , time_curr_)
!
use NonLin_Datastructure_type
use HHO_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/r8nnem.h"
#include "asterfort/NonLinear_type.h"
#include "asterfort/assert.h"
#include "asterfort/nmfint.h"
#include "asterfort/nonlinNForceCompute.h"
#include "asterfort/nonlinIntForceAsse.h"
!
integer, intent(in) :: phaseType
character(len=24), intent(in) :: model, cara_elem
integer, intent(in) :: list_func_acti(*)
character(len=19), intent(in) :: sdnume
type(NL_DS_Material), intent(in) :: ds_material
type(NL_DS_Constitutive), intent(in) :: ds_constitutive
type(NL_DS_System), intent(in) :: ds_system
type(NL_DS_Measure), intent(inout) :: ds_measure
integer, intent(in) :: iter_newt
character(len=19), intent(in) :: hval_incr(*), hval_algo(*)
integer, intent(out) :: ldccvg
type(HHO_Field), optional, intent(in) :: hhoField_
character(len=19), optional, intent(in) :: sddyna_
real(kind=8), optional, intent(in) :: time_prev_, time_curr_
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Algorithm
!
! Compute internal forces
!
! --------------------------------------------------------------------------------------------------
!
! In  phaseType        : name of current phase (prediction/correction/internal forces)
! In  model            : name of model
! In  cara_elem        : name of elementary characteristics (field)
! In  list_func_acti   : list of active functionnalities
! In  sddyna           : datastructure for dynamic
! In  sdnume           : datastructure for dof positions
! In  ds_material      : datastructure for material parameters
! In  ds_constitutive  : datastructure for constitutive laws management
! In  ds_system        : datastructure for non-linear system management
! IO  ds_measure       : datastructure for measure and statistics management
! In  time_prev        : time at beginning of time step
! In  time_curr        : time at end of time step
! In  iter_newt        : index of current Newton iteration
! In  hval_incr        : hat-variable for incremental values fields
! In  hval_algo        : hat-variable for algorithms fields
! In  hhoField         : datastructure for HHO
! Out ldccvg           : indicator from integration of behaviour
!                -1 : PAS D'INTEGRATION DU COMPORTEMENT
!                 0 : CAS DE FONCTIONNEMENT NORMAL
!                 1 : ECHEC DE L'INTEGRATION DE LA LDC
!                 3 : SIZZ PAS NUL POUR C_PLAN DEBORST
!
! --------------------------------------------------------------------------------------------------
!
    character(len=19) :: sddyna
    type(HHO_Field) :: hhoField
    real(kind=8) :: time_prev, time_curr
!
! --------------------------------------------------------------------------------------------------
!
    sddyna    = ' '
    time_prev = r8nnem()
    time_curr = r8nnem()
    if (present(sddyna_)) then
        sddyna = sddyna_
    endif
    if (present(time_prev_)) then
        time_prev = time_prev_
        time_curr = time_curr_
    endif
    if (present(hhoField_)) then
        hhoField = hhoField_
    endif
    if (phaseType .eq. PRED_EULER) then
        ASSERT(iter_newt .eq. 0)
! ----- Direct computation (no integration of behaviour)
        call nonlinNForceCompute(model      , cara_elem      , list_func_acti,&
                                 ds_material, ds_constitutive,&
                                 ds_measure , ds_system      ,&
                                 time_prev  , time_curr      ,&
                                 hval_incr  , hval_algo)
! ----- Integration of behaviour
        call nmfint(model         , cara_elem      ,&
                    ds_material   , ds_constitutive,&
                    list_func_acti, iter_newt      , ds_measure, ds_system,&
                    hval_incr     , hval_algo      , hhoField,&
                    ldccvg        , sddyna)
! ----- Assembly
        if (ldccvg .ne. 1) then
            call nonlinIntForceAsse(INTE_FORCE_FNOD, list_func_acti, sdnume, ds_material, ds_system)
        endif
    elseif (phaseType .eq. CORR_NEWTON) then
! ----- Integration of behaviour
        call nmfint(model         , cara_elem      ,&
                    ds_material   , ds_constitutive,&
                    list_func_acti, iter_newt      , ds_measure, ds_system,&
                    hval_incr     , hval_algo      , hhoField,&
                    ldccvg        , sddyna)
! ----- Assembly
        if (ldccvg .ne. 1) then
            call nonlinIntForceAsse(INTE_FORCE_INTE, list_func_acti, sdnume, ds_material, ds_system)
        endif
    else
        ASSERT(ASTER_FALSE)
    endif
!
end subroutine
