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
interface
    subroutine as_mlclor(fid, tr1, tr2, tr3, nbt,&
                      k64, cret)
        aster_int :: fid
        real(kind=8) :: tr1(*)
        real(kind=8) :: tr2(*)
        real(kind=8) :: tr3(*)
        aster_int :: nbt
        character(len=64) :: k64
        aster_int :: cret
    end subroutine as_mlclor
end interface
