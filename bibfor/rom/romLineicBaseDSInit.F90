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

subroutine romLineicBaseDSInit(ds_lineicnumb)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(ROM_DS_LineicNumb), intent(out) :: ds_lineicnumb
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Initializations
!
! Initialization of datastructure for lineic base numbering
!
! --------------------------------------------------------------------------------------------------
!
! Out ds_lineicnumb    : datastructure for lineic base numbering
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM2_6')
    endif
!
! - Create parameters datastructure
!
    ds_lineicnumb%tole_node = 1.d-7
    ds_lineicnumb%nb_slice  = 0
    ds_lineicnumb%v_nume_pl => null()
    ds_lineicnumb%v_nume_sf => null()
!
end subroutine
