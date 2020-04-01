! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
#include "asterf_types.h"
!
interface
    subroutine cleanListOfGrpMa(mesh, listGrpMa, nbGrpMa, l_stop, iret)
        character(len=*), intent(in)    :: mesh
        character(len=*), intent(inout) :: listGrpMa(*)
        integer, intent(inout)          :: nbGrpMa
        aster_logical, intent(in)       :: l_stop
        integer, intent(out)            :: iret
    end subroutine cleanListOfGrpMa
end interface
