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
!
subroutine nmmeng(list_func_acti,&
                  ds_algorom, ds_print, ds_measure,&
                  ds_energy , ds_inout, ds_posttimestep)
!
use NonLin_Datastructure_type
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/detmat.h"
#include "asterfort/isfonc.h"
#include "asterfort/romAlgoNLClean.h"
#include "asterfort/nonlinDSPrintClean.h"
#include "asterfort/nonlinDSMeasureClean.h"
#include "asterfort/nonlinDSEnergyClean.h"
#include "asterfort/nonlinDSPostTimeStepClean.h"
#include "asterfort/nonlinDSInOutClean.h"
!
integer, intent(in) :: list_func_acti(*)
type(ROM_DS_AlgoPara), intent(inout) :: ds_algorom
type(NL_DS_Print), intent(inout) :: ds_print
type(NL_DS_Energy), intent(inout) :: ds_energy
type(NL_DS_Measure), intent(inout) :: ds_measure
type(NL_DS_InOut), intent(inout) :: ds_inout
type(NL_DS_PostTimeStep), intent(inout) :: ds_posttimestep
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Algorithm
!
! Cleaning datastructures
!
! --------------------------------------------------------------------------------------------------
!
! In  list_func_acti   : list of active functionnalities
! IO  ds_algorom       : datastructure for ROM parameters
! IO  ds_print         : datastructure for printing parameters
! IO  ds_energy        : datastructure for energy management
! IO  ds_measure       : datastructure for measure and statistics management
! IO  ds_inout         : datastructure for input/output management
! IO  ds_posttimestep  : datastructure for post-treatment at each time step
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: l_rom
!
! --------------------------------------------------------------------------------------------------
!
    l_rom = isfonc(list_func_acti,'ROM')
    if (l_rom) then
        call romAlgoNLClean(ds_algorom)
    endif
!
! - De-allocate
!
    call nonlinDSPrintClean(ds_print)
    call nonlinDSMeasureClean(ds_measure)
    call nonlinDSEnergyClean(ds_energy)
    call nonlinDSInOutClean(ds_inout)
    call nonlinDSPostTimeStepClean(ds_posttimestep)
!
! - DESTRUCTION DE TOUTES LES MATRICES CREEES
!
    call detmat()
!
end subroutine
