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
!    
subroutine nonlinDSPrintHeadTimeStep(sddisc, nume_inst, ds_print)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/nmimpt.h"
#include "asterfort/nmimpx.h"
!
character(len=19), intent(in) :: sddisc
integer, intent(in) :: nume_inst
type(NL_DS_Print), intent(inout) :: ds_print
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Print management
!
! Initializations for new step time
!
! --------------------------------------------------------------------------------------------------
!
! In  sddisc           : name of datastructure for time discretization
! In  nume_inst        : index of current time step
! IO  ds_print         : datastructure for printing parameters
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: l_print
!
! --------------------------------------------------------------------------------------------------
!
    l_print = mod(nume_inst+1,ds_print%reac_print) .eq. 0
    ds_print%l_print = l_print
!
! - Print separator line
!
    if (l_print) then
        call nmimpx(ds_print)
    endif
!
! - Print head of convergence table
!
    if (l_print) then
        call nmimpt(nume_inst, sddisc, ds_print)
    endif
!
end subroutine
