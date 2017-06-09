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
    subroutine hujjid(mod, mater, indi, deps, prox,&
                      proxc, yd, yf, vind, r,&
                      drdy, iret)
        character(len=8) :: mod
        real(kind=8) :: mater(22, 2)
        integer :: indi(7)
        real(kind=8) :: deps(6)
        aster_logical :: prox(4)
        aster_logical :: proxc(4)
        real(kind=8) :: yd(18)
        real(kind=8) :: yf(18)
        real(kind=8) :: vind(*)
        real(kind=8) :: r(18)
        real(kind=8) :: drdy(18, 18)
        integer :: iret
    end subroutine hujjid
end interface
