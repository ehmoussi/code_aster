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
subroutine nonlinDSEnergyClean(ds_energy)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/nonlinDSTableIOClean.h"
!
type(NL_DS_Energy), intent(inout) :: ds_energy
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Energy management
!
! Clean energy management datastructure
!
! --------------------------------------------------------------------------------------------------
!
! IO  ds_energy        : datastructure for energy management
!
! --------------------------------------------------------------------------------------------------
!
    call nonlinDSTableIOClean(ds_energy%table%table_io)
!
end subroutine
