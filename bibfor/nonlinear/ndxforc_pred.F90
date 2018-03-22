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
subroutine ndxforc_pred(list_func_acti,&
                        model         , cara_elem      ,&
                        nume_dof      , &
                        list_load     , sddyna         ,&
                        ds_material   , ds_constitutive,&
                        ds_measure    , &
                        sddisc        , nume_inst      ,&
                        hval_incr     , hval_algo      ,&
                        hval_veelem   , hval_veasse    ,&
                        hval_measse   , ldccvg)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infdbg.h"
#include "asterfort/utmess.h"
#include "asterfort/ndfdyn.h"
#include "asterfort/diinst.h"
#include "asterfort/ndynlo.h"
#include "asterfort/isfonc.h"
#include "asterfort/nmchex.h"
#include "asterfort/nonlinRForceCompute.h"
#include "asterfort/nonlinDynaMDampCompute.h"
#include "asterfort/nonlinDynaImpeCompute.h"
#include "asterfort/nonlinLoadCompute.h"
#include "asterfort/nonlinSubStruCompute.h"
#include "asterfort/nmfint.h"
#include "asterfort/assvec.h"
!
integer, intent(in) :: list_func_acti(*)
character(len=24), intent(in) :: model, cara_elem, nume_dof
character(len=19), intent(in) :: list_load, sddyna
type(NL_DS_Material), intent(in) :: ds_material
type(NL_DS_Constitutive), intent(in) :: ds_constitutive
type(NL_DS_Measure), intent(inout) :: ds_measure
character(len=19), intent(in) :: sddisc
integer, intent(in) :: nume_inst
character(len=19), intent(in) :: hval_incr(*), hval_algo(*)
character(len=19), intent(in) :: hval_veelem(*), hval_veasse(*)
character(len=19), intent(in) :: hval_measse(*)
integer, intent(out) :: ldccvg
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Algorithm
!
! Compute forces for second member at prediction for explicit algorithm
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
! In  sddisc           : datastructure for time discretization
! In  nume_inst        : index of current time step
! In  hval_incr        : hat-variable for incremental values fields
! In  hval_algo        : hat-variable for algorithms fields
! In  hval_veelem      : hat-variable for elementary vectors
! In  hval_veasse      : hat-variable for vectors (node fields)
! In  hval_measse      : hat-variable for matrix
! Out ldccvg           : indicator from integration of behaviour
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=24) :: mate, varc_refe
    character(len=19) :: cndyna, cnsstr, vefint, cnfint
    character(len=19) :: disp_prev, vite_prev, acce_prev
    character(len=19) :: disp_curr, vite_curr, acce_curr
    real(kind=8) :: time_prev, time_curr
    aster_logical :: l_impe, l_ammo, l_macr
    integer :: iterat
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECANONLINE', ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'MECANONLINE11_21')
    endif
!
! - Initializations
!
    ldccvg    = 0
    mate      = ds_material%field_mate
    varc_refe = ds_material%varc_refe
!
! - Get time
!
    ASSERT(nume_inst .gt. 0)
    time_prev = diinst(sddisc,nume_inst-1)
    time_curr = diinst(sddisc,nume_inst)
!
! - Active functionnalities
!
    l_impe   = ndynlo(sddyna,'IMPE_ABSO')
    l_ammo   = ndynlo(sddyna,'AMOR_MODAL')
    l_macr   = isfonc(list_func_acti,'MACR_ELEM_STAT')
!
! - Get hat variables
!
    call nmchex(hval_incr, 'VALINC', 'DEPMOI', disp_prev)
    call nmchex(hval_incr, 'VALINC', 'VITMOI', vite_prev)
    call nmchex(hval_incr, 'VALINC', 'ACCMOI', acce_prev)
    call nmchex(hval_incr, 'VALINC', 'DEPPLU', disp_curr)
    call nmchex(hval_incr, 'VALINC', 'ACCPLU', acce_curr)
    call nmchex(hval_incr, 'VALINC', 'VITPLU', vite_curr)
!
! - Compute loads (undead)
!
    call nonlinLoadCompute('VARI'     , list_load      ,&
                           model      , cara_elem      , nume_dof  , list_func_acti,&
                           ds_material, ds_constitutive, ds_measure,&
                           time_prev  , time_curr      ,&
                           hval_incr  , hval_algo      ,&
                           hval_veelem, hval_veasse)
!
! - Compute sub-structuring effect on second member
!
    if (l_macr) then
        call nmchex(hval_veasse, 'VEASSE', 'CNSSTR', cnsstr)
        call nonlinSubStruCompute(ds_measure , disp_curr,&
                                  hval_measse, cnsstr)
    endif
!
! - Compute force for Dirichlet boundary conditions (dualized) - BT.LAMBDA
!
    call nonlinRForceCompute(model      , ds_material, cara_elem, list_load,&
                             nume_dof   , ds_measure , acce_prev,&
                             hval_veelem, hval_veasse)
!
! - Compute effect of dynamic forces (from time discretization scheme)
!
    call nmchex(hval_veasse, 'VEASSE', 'CNDYNA', cndyna)
    call ndfdyn(sddyna, hval_measse, ds_measure, vite_curr, acce_curr,&
                cndyna)
!
! - Compute modal damping
!
    if (l_ammo) then
        call nonlinDynaMDampCompute('Prediction', sddyna    ,&
                                    nume_dof    , ds_measure,&
                                    hval_incr   , hval_veasse)
    endif
!
! - Compute impedance
!
    if (l_impe) then
        call nonlinDynaImpeCompute('Prediction', sddyna    ,&
                                   model       , nume_dof  ,&
                                   ds_material , ds_measure,&
                                   hval_incr   ,&
                                   hval_veelem , hval_veasse)
    endif
!
! - Compute internal forces
!
    iterat = 0
    call nmchex(hval_veasse, 'VEASSE', 'CNFINT', cnfint)
    call nmchex(hval_veelem, 'VEELEM', 'CNFINT', vefint)
    call nmfint(model         , mate  , cara_elem, varc_refe , ds_constitutive,&
                list_func_acti, iterat, sddyna   , ds_measure, hval_incr      ,&
                hval_algo     , ldccvg, vefint)
    if (ldccvg .eq. 0) then
        call assvec('V', cnfint, 1, vefint, [1.d0], nume_dof, ' ', 'ZERO', 1)
    endif
!
end subroutine
