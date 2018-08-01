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
! aslint: disable=W1403
!
subroutine romLineicBaseDSInit(ds_lineicnumb)
!
use Rom_Datastructure_type
!
implicit none
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
    ds_lineicnumb%tole_node = 1.d-7
!
end subroutine
