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
subroutine nonlinLoadDynaCompute(mode       , sddyna     ,&
                                 model      , nume_dof   ,&
                                 ds_material, ds_measure , ds_inout,&
                                 time_prev  , time_curr  ,&
                                 hval_veelem, hval_veasse)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infdbg.h"
#include "asterfort/ndynlo.h"
#include "asterfort/nmtime.h"
#include "asterfort/nmchex.h"
#include "asterfort/veondp.h"
#include "asterfort/asasve.h"
#include "asterfort/ascova.h"
#include "asterfort/nmviss.h"
!
character(len=4), intent(in) :: mode
character(len=19), intent(in) :: sddyna
character(len=24), intent(in) :: model, nume_dof
type(NL_DS_Material), intent(in) :: ds_material
type(NL_DS_Measure), intent(inout) :: ds_measure
type(NL_DS_InOut), intent(in) :: ds_inout
real(kind=8), intent(in) :: time_prev, time_curr
character(len=19), intent(in) :: hval_veelem(*), hval_veasse(*)
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Algorithm
!
! Compute forces (dynamic)
!
! --------------------------------------------------------------------------------------------------
!
! In  mode             : 'FIXE'-> dead loads 
!                        'VARI'-> undead loads
!                        'ACCI'-> initial acceleration (dynamic)
! In  sddyna           : datastructure for dynamic
! In  model            : name of model
! In  nume_dof         : name of numbering object (NUME_DDL)
! In  ds_material      : datastructure for material parameters
! IO  ds_measure       : datastructure for measure and statistics management
! In  ds_inout         : datastructure for input/output management
! In  time_prev        : time at beginning of time step
! In  time_curr        : time at end of time step
! In  hval_veelem      : hat-variable for elementary vectors
! In  hval_veasse      : hat-variable for vectors (node fields)
!
! --------------------------------------------------------------------------------------------------
!
    character(len=19) :: vect_elem, vect_asse
    character(len=24) :: vect_alem
    aster_logical :: l_wave, l_viss
!
! --------------------------------------------------------------------------------------------------
!  
    l_wave = ndynlo(sddyna,'ONDE_PLANE')
    l_viss = ndynlo(sddyna,'VECT_ISS')
!
! - Launch timer
!
    call nmtime(ds_measure, 'Init'  , '2nd_Member')
    call nmtime(ds_measure, 'Launch', '2nd_Member')
!
! - Wave (ONDE_PLANE)
!
    if (l_wave) then
        if (mode .eq. 'FIXE') then
            call nmchex(hval_veelem, 'VEELEM', 'CNONDP', vect_elem)
            call nmchex(hval_veasse, 'VEASSE', 'CNONDP', vect_asse)
            call veondp(model, ds_material%field_mate, sddyna, time_curr,&
                        vect_elem)
            call asasve(vect_elem, nume_dof, 'R', vect_alem)
            call ascova('D', vect_alem, ' ', 'INST', time_curr,&
                        'R', vect_asse)
        endif
    endif
!
! - FORCE_SOL
!
    if (l_viss) then
        if (mode .eq. 'FIXE' .or. mode .eq. 'ACCI') then
            call nmchex(hval_veasse, 'VEASSE', 'CNVISS', vect_asse)
            call nmviss(nume_dof, sddyna, ds_inout, time_prev, time_curr,&
                        vect_asse)
        endif
    endif
!
! - Stop timer
!
    call nmtime(ds_measure, 'Stop', '2nd_Member')
!
end subroutine
