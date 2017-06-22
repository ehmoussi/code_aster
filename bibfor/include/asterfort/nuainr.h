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
    subroutine nuainr(method, np1, nx1, nc1, ic1,&
                      nuax1, nual1, nuav1, x2, dref,&
                      val2)
        integer :: nx1
        character(len=*) :: method
        integer :: np1
        integer :: nc1
        integer :: ic1
        real(kind=8) :: nuax1(*)
        aster_logical :: nual1(*)
        real(kind=8) :: nuav1(*)
        real(kind=8) :: x2(nx1)
        real(kind=8) :: dref
        real(kind=8) :: val2
    end subroutine nuainr
end interface
