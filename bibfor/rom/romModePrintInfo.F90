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
subroutine romModePrintInfo(ds_mode)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
!
type(ROM_DS_Field), intent(in) :: ds_mode
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Print informations about empiric mode
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_mode          : datastructure for empiric mode
!
! --------------------------------------------------------------------------------------------------
!
    call utmess('I', 'ROM3_4', sk = ds_mode%field_name)
    call utmess('I', 'ROM3_6', si = ds_mode%nb_node)
    call utmess('I', 'ROM3_7', si = ds_mode%nb_equa)
!
end subroutine
