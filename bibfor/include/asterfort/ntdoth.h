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

!
!
#include "asterf_types.h"
!
interface
    subroutine ntdoth(model     , mate   , cara_elem, list_load, result, &
                      nume_store, matcst_, coecst_  )
        character(len=24), intent(out) :: model
        character(len=24), intent(out) :: cara_elem
        character(len=24), intent(out) :: mate
        character(len=19), intent(inout) :: list_load
        character(len=8), optional, intent(in) :: result
        integer, optional, intent(in) :: nume_store
        aster_logical, optional, intent(out) :: matcst_
        aster_logical, optional, intent(out) :: coecst_
    end subroutine ntdoth
end interface
