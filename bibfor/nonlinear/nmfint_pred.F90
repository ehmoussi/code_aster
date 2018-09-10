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
subroutine nmfint_pred(model      , cara_elem      , list_func_acti,&
                       sddyna     , nume_dof       , &
                       ds_material, ds_constitutive, ds_measure    ,&
                       time_prev  , time_curr      , iter_newt     ,&
                       hval_incr  , hval_algo      ,&
                       hval_veelem, hval_veasse    ,&
                       ldccvg     , sdnume_)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infdbg.h"
#include "asterfort/utmess.h"
#include "asterfort/nmaint.h"
#include "asterfort/nmfint.h"
#include "asterfort/nmchex.h"
#include "asterfort/assvec.h"
#include "asterfort/nonlinNForceCompute.h"
!
character(len=24), intent(in) :: model, cara_elem
integer, intent(in) :: list_func_acti(*)
character(len=19), intent(in) :: sddyna
character(len=24), intent(in) :: nume_dof
type(NL_DS_Material), intent(in) :: ds_material
type(NL_DS_Constitutive), intent(in) :: ds_constitutive
type(NL_DS_Measure), intent(inout) :: ds_measure
real(kind=8), intent(in) :: time_prev, time_curr
integer, intent(in) :: iter_newt
character(len=19), intent(in) :: hval_incr(*), hval_algo(*)
character(len=19), intent(in) :: hval_veelem(*), hval_veasse(*)
integer, intent(out) :: ldccvg
character(len=19), optional, intent(in) :: sdnume_
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Algorithm
!
! Compute internal forces at prediction
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of model
! In  cara_elem        : name of elementary characteristics (field)
! In  nume_dof         : name of numbering object (NUME_DDL)
! In  list_func_acti   : list of active functionnalities
! In  sddyna           : datastructure for dynamic
! In  sdnume           : datastructure for dof positions
! In  ds_material      : datastructure for material parameters
! In  ds_constitutive  : datastructure for constitutive laws management
! IO  ds_measure       : datastructure for measure and statistics management
! In  time_prev        : time at beginning of time step
! In  time_curr        : time at end of time step
! In  iter_newt        : index of current Newton iteration
! In  hval_incr        : hat-variable for incremental values fields
! In  hval_algo        : hat-variable for algorithms fields
! In  hval_veelem      : hat-variable for elementary vectors
! In  hval_veasse      : hat-variable for vectors (node fields)
! Out ldccvg           : indicator from integration of behaviour
!                -1 : PAS D'INTEGRATION DU COMPORTEMENT
!                 0 : CAS DE FONCTIONNEMENT NORMAL
!                 1 : ECHEC DE L'INTEGRATION DE LA LDC
!                 3 : SIZZ PAS NUL POUR C_PLAN DEBORST
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=19) :: vefint, cnfint
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECANONLINE', ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'MECANONLINE11_27')
    endif
!
! - Direct computation (no integration of behaviour)
!
    if (ds_constitutive%l_pred_cnfnod) then
        call nonlinNForceCompute(model      , cara_elem      , nume_dof  , list_func_acti,&
                                 ds_material, ds_constitutive, ds_measure,&
                                 time_prev  , time_curr      ,&
                                 hval_incr  , hval_algo      ,&
                                 hval_veelem, hval_veasse)

    endif
!
! - Integration of behaviour
!
    if (ds_constitutive%l_pred_cnfint) then
        call nmchex(hval_veasse, 'VEASSE', 'CNFINT', cnfint)
        call nmchex(hval_veelem, 'VEELEM', 'CNFINT', vefint)
        call nmfint(model         , cara_elem      ,&
                    ds_material   , ds_constitutive,&
                    list_func_acti, iter_newt      , sddyna, ds_measure,&
                    hval_incr     , hval_algo      ,&
                    vefint        , ldccvg )
        if (ldccvg .eq. 0) then
            if (present(sdnume_)) then
                call nmaint(nume_dof, list_func_acti, sdnume_,&
                            vefint  , cnfint)
            else
                call assvec('V', cnfint, 1, vefint, [1.d0], nume_dof, ' ', 'ZERO', 1)
            endif
        endif
    endif
!
end subroutine
