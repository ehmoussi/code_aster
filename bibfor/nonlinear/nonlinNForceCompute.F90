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
! person_in_lload_name: mickael.abbas at edf.fr
!
subroutine nonlinNForceCompute(model      , cara_elem      , nume_dof  , list_func_acti,&
                               ds_material, ds_constitutive, ds_measure,&
                               time_prev  , time_curr      ,&
                               hval_incr  , hval_algo      ,&
                               hval_veelem, hval_veasse)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infdbg.h"
#include "asterfort/isfonc.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmvcex.h"
#include "asterfort/vefnme.h"
#include "asterfort/assvec.h"
#include "asterfort/nmtime.h"
#include "asterfort/nmdep0.h"
!
character(len=24), intent(in) :: model, cara_elem, nume_dof
integer, intent(in) :: list_func_acti(*)
type(NL_DS_Material), intent(in) :: ds_material
type(NL_DS_Constitutive), intent(in) :: ds_constitutive
type(NL_DS_Measure), intent(inout) :: ds_measure
real(kind=8), intent(in) :: time_prev, time_curr
character(len=19), intent(in) :: hval_incr(*), hval_algo(*)
character(len=19), intent(in) :: hval_veelem(*), hval_veasse(*)
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Algorithm
!
! Compute nodal force BT . SIGMA (No integration of behaviour)
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of model
! In  cara_elem        : name of elementary characteristics (field)
! In  nume_dof         : name of numbering object (NUME_DDL)
! In  list_func_acti   : list of active functionnalities
! In  ds_material      : datastructure for material parameters
! In  ds_constitutive  : datastructure for constitutive laws management
! IO  ds_measure       : datastructure for measure and statistics management
! In  time_prev        : time at beginning of time step
! In  time_curr        : time at end of time step
! In  hval_incr        : hat-variable for incremental values fields
! In  hval_algo        : hat-variable for algorithms fields
! In  hval_veelem      : hat-variable for elementary vectors
! In  hval_veasse      : hat-variable for vectors (node fields)
!
! --------------------------------------------------------------------------------------------------
!
    character(len=19) :: vect_elem, vect_asse
    real(kind=8) :: time_list(2)
    character(len=19) :: disp_prev, strx_prev, sigm_prev, varc_prev
    character(len=19) :: disp_cumu_inst, sigm_extr
    character(len=24) :: vrcmoi
    character(len=16) :: option
    aster_logical :: l_implex
!
! --------------------------------------------------------------------------------------------------
!
    option = 'FORC_NODA'
!
! - Set disp_cumu_inst to zero
!
    call nmdep0('ON ', hval_algo)
!
! - Hat variable
!
    call nmchex(hval_veelem, 'VEELEM', 'CNFNOD', vect_elem)
    call nmchex(hval_veasse, 'VEASSE', 'CNFNOD', vect_asse)
    call nmchex(hval_algo, 'SOLALG', 'DEPDEL', disp_cumu_inst)
    call nmchex(hval_incr, 'VALINC', 'DEPMOI', disp_prev)
    call nmchex(hval_incr, 'VALINC', 'STRMOI', strx_prev)
    call nmchex(hval_incr, 'VALINC', 'SIGMOI', sigm_prev)
    call nmchex(hval_incr, 'VALINC', 'SIGEXT', sigm_extr)
    call nmchex(hval_incr, 'VALINC', 'COMMOI', varc_prev)
    call nmvcex('TOUT', varc_prev, vrcmoi)
!
    l_implex     = isfonc(list_func_acti,'IMPLEX')
!
! - Time
!
    time_list(1) = time_prev
    time_list(2) = time_curr
!
! - Launch timer
!
    call nmtime(ds_measure, 'Init'  , '2nd_Member')
    call nmtime(ds_measure, 'Launch', '2nd_Member')
!
! - Compute
!
    if (l_implex) then
        call vefnme(option                , model         , ds_material%field_mate, cara_elem,&
                    ds_constitutive%compor, time_list     , 0                     , ' '      ,&
                    vrcmoi                , sigm_extr     , ' ',&
                    disp_prev             , disp_cumu_inst,&
                    'V'                   , vect_elem)
    else
        call vefnme(option                , model         , ds_material%field_mate, cara_elem,&
                    ds_constitutive%compor, time_list     , 0                     , ' '      ,&
                    vrcmoi                , sigm_prev     , strx_prev,&
                    disp_prev             , disp_cumu_inst,&
                    'V'                   , vect_elem)
    endif
    call assvec('V', vect_asse, 1, vect_elem, [1.d0],&
                 nume_dof, ' ', 'ZERO', 1)
!
! - Restore disp_cumu_inst
!
    call nmdep0('OFF', hval_algo)
!
! - Stop timer
!
    call nmtime(ds_measure, 'Stop', '2nd_Member')
!
end subroutine
