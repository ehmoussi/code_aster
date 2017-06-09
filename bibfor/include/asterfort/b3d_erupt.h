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
    subroutine b3d_erupt(local, i, l3, e23, r,&
                         beta, epic, fr, gf, e,&
                         dpic)
#include "asterf_types.h"
        aster_logical :: local
        integer :: i
        real(kind=8) :: l3(3)
        real(kind=8) :: e23(3)
        real(kind=8) :: r
        real(kind=8) :: beta
        real(kind=8) :: epic
        real(kind=8) :: fr
        real(kind=8) :: gf
        real(kind=8) :: e
        real(kind=8) :: dpic
    end subroutine b3d_erupt
end interface 
