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
interface 
    subroutine b3d_l3(local, t33, n33, vt33, vss33,&
                      l3)
#include "asterf_types.h"
        aster_logical :: local
        real(kind=8) :: t33(3, 3)
        real(kind=8) :: n33(3, 3)
        real(kind=8) :: vt33(3, 3)
        real(kind=8) :: vss33(3, 3)
        real(kind=8) :: l3(3)
    end subroutine b3d_l3
end interface 
