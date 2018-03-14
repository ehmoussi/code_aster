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
subroutine nonlinLoadCompute(mode       , list_load      ,&
                             model      , cara_elem      , nume_dof  , list_func_acti,&
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
#include "asterfort/vedime.h"
#include "asterfort/asasve.h"
#include "asterfort/ascova.h"
#include "asterfort/vedpme.h"
#include "asterfort/assvec.h"
#include "asterfort/velame.h"
#include "asterfort/vecgme.h"
#include "asterfort/vefpme.h"
#include "asterfort/nmcvci.h"
#include "asterfort/vechme.h"
#include "asterfort/nmtime.h"
#include "asterfort/nmsssv.h"
#include "asterfort/assvss.h"
!
character(len=4), intent(in) :: mode
character(len=19), intent(in) :: list_load
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
! Compute forces
!
! --------------------------------------------------------------------------------------------------
!
! In  mode             : 'FIXE'-> dead loads 
!                        'VARI'-> undead loads
!                        'ACCI'-> initial acceleration (dynamic)
! In  list_load        : name of datastructure for list of loads
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
    character(len=24) :: lload_name, lload_info, lload_func, lload_fcss
    character(len=19) :: vect_elem, vect_asse
    character(len=24) :: vect_alem
    aster_logical :: l_pilo, l_lapl, l_diri_undead, l_sstf
    real(kind=8) :: time_list(3)
    character(len=19) :: disp_prev, strx_prev
    character(len=19) :: vite_curr, varc_curr, disp_curr
    character(len=19) :: disp_cumu_inst
    character(len=24) :: vrcplu
!
! --------------------------------------------------------------------------------------------------
!
    lload_name    = list_load(1:19)//'.LCHA'
    lload_info    = list_load(1:19)//'.INFC'
    lload_func    = list_load(1:19)//'.FCHA'
    lload_fcss    = list_load(1:19)//'.FCSS'  
!
    l_lapl        = isfonc(list_func_acti,'LAPLACE')
    l_pilo        = isfonc(list_func_acti,'PILOTAGE')
    l_diri_undead = isfonc(list_func_acti,'DIRI_UNDEAD')
    l_sstf        = isfonc(list_func_acti,'SOUS_STRUC')
!
! - Hat variable
!
    call nmchex(hval_algo, 'SOLALG', 'DEPDEL', disp_cumu_inst)
    call nmchex(hval_incr, 'VALINC', 'DEPMOI', disp_prev)
    call nmchex(hval_incr, 'VALINC', 'STRMOI', strx_prev)
    call nmchex(hval_incr, 'VALINC', 'DEPPLU', disp_curr)
    call nmchex(hval_incr, 'VALINC', 'VITPLU', vite_curr)
    call nmchex(hval_incr, 'VALINC', 'COMPLU', varc_curr)
    call nmvcex('TOUT', varc_curr, vrcplu)
!
! - Time
!
    time_list(1) = time_curr
    time_list(2) = time_curr-time_prev
    time_list(3) = 0.d0
!
! - Launch timer
!
    call nmtime(ds_measure, 'Init'  , '2nd_Member')
    call nmtime(ds_measure, 'Launch', '2nd_Member')
!
! - Dirichlet (AFFE_CHAR_MECA)
!
    if (mode .eq. 'FIXE' .or. mode .eq. 'ACCI' .or.&
        (mode .eq. 'VARI' .and. l_diri_undead)) then
        call nmchex(hval_veelem, 'VEELEM', 'CNDIDO', vect_elem)
        call nmchex(hval_veasse, 'VEASSE', 'CNDIDO', vect_asse)
        call vedime(model, lload_name, lload_info, time_curr, 'R',&
                    vect_elem)
        call asasve(vect_elem, nume_dof, 'R', vect_alem)
        call ascova('D', vect_alem, lload_func, 'INST', time_curr,&
                    'R', vect_asse)
    endif
!
! - Dirichlet (AFFE_CHAR_CINE)
!
    if (mode .eq. 'FIXE' .or. mode .eq. 'ACCI') then
        call nmchex(hval_veasse, 'VEASSE', 'CNCINE', vect_asse)
        call nmcvci(lload_name, lload_info, lload_func, nume_dof, disp_prev,&
                    time_curr, vect_asse)
    endif
!
! - Neumann (dead)
!
    if (mode .eq. 'FIXE' .or. mode .eq. 'ACCI') then
        call nmchex(hval_veelem, 'VEELEM', 'CNFEDO', vect_elem)
        call nmchex(hval_veasse, 'VEASSE', 'CNFEDO', vect_asse)
        call vechme('S', model, lload_name, lload_info, time_list,&
                    cara_elem, ds_material%field_mate, vect_elem, varc_currz = vrcplu)
        call asasve(vect_elem, nume_dof, 'R', vect_alem)
        call ascova('D', vect_alem, lload_func, 'INST', time_curr,&
                    'R', vect_asse)
    endif
!
! - Laplace
!
    if (l_lapl) then
        if (mode .eq. 'FIXE') then
            call nmchex(hval_veelem, 'VEELEM', 'CNLAPL', vect_elem)
            call nmchex(hval_veasse, 'VEASSE', 'CNLAPL', vect_asse)
            call velame(model, lload_name, lload_info, disp_prev,&
                        vect_elem)
            call asasve(vect_elem, nume_dof, 'R', vect_alem)
            call ascova('D', vect_alem, lload_func, 'INST', time_curr,&
                        'R', vect_asse)
        endif
    endif
!
! - Neumann (PILOTAGE)
!
    if (l_pilo) then
        if (mode .eq. 'FIXE') then
            call nmchex(hval_veelem, 'VEELEM', 'CNDIPI', vect_elem)
            call nmchex(hval_veasse, 'VEASSE', 'CNDIPI', vect_asse)
            call vedpme(model, lload_name, lload_info, time_curr,&
                        vect_elem)
            call assvec('V', vect_asse, 1, vect_elem, [1.d0],&
                        nume_dof, ' ', 'ZERO', 1)
        endif
    endif
!
! - Dirichlet (PILOTAGE)
!
    if (l_pilo) then
        if (mode .eq. 'FIXE') then
            call nmchex(hval_veelem, 'VEELEM', 'CNFEPI', vect_elem)
            call nmchex(hval_veasse, 'VEASSE', 'CNFEPI', vect_asse)
            call vefpme(model     , cara_elem , ds_material%field_mate,&
                        lload_name, lload_info,&
                        time_list , vrcplu    , vect_elem, ' ')
            call asasve(vect_elem, nume_dof, 'R', vect_alem)
            call ascova('D', vect_alem, lload_func, 'INST', time_curr,&
                        'R', vect_asse)
        endif
    endif
!
! - Neumann (undead)
!
    if (mode .eq. 'VARI' .or. mode .eq. 'ACCI') then
        call nmchex(hval_veelem, 'VEELEM', 'CNFSDO', vect_elem)
        call nmchex(hval_veasse, 'VEASSE', 'CNFSDO', vect_asse)
        call vecgme(model, cara_elem, ds_material%field_mate,&
                    lload_name, lload_info,&
                    time_curr, disp_prev, disp_cumu_inst, vect_elem, time_prev,&
                    ds_constitutive%compor, ' '   , vite_curr, strx_prev)
        call asasve(vect_elem, nume_dof, 'R', vect_alem)
        call ascova('D', vect_alem, lload_func, 'INST', time_curr,&
                    'R', vect_asse)
    endif
!
! - Dynamic sub-structuring
!
    if (l_sstf) then
        if (mode .eq. 'FIXE' .or. mode .eq. 'ACCI') then
            call nmchex(hval_veelem, 'VEELEM', 'CNSSTF', vect_elem)
            call nmchex(hval_veasse, 'VEASSE', 'CNSSTF', vect_asse)
            call nmsssv(model, ds_material%field_mate, cara_elem, list_load,&
                        vect_elem)
            call assvss('V', vect_asse, vect_elem, nume_dof, ' ',&
                        'ZERO', 1, lload_fcss, time_curr)
        endif
    endif
!
! - Stop timer
!
    call nmtime(ds_measure, 'Stop', '2nd_Member')
!
end subroutine
