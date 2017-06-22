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
    subroutine pjefmi(elrefp, nnop, coor, xg, ndim,&
                      x1, x2, lext, xmi, distv)
        integer :: ndim
        integer :: nnop
        character(len=8) :: elrefp
        real(kind=8) :: coor(ndim*nnop)
        real(kind=8) :: xg(ndim)
        real(kind=8) :: x1(ndim)
        real(kind=8) :: x2(ndim)
        aster_logical :: lext
        real(kind=8) :: xmi(ndim)
        real(kind=8),intent(out) :: distv
    end subroutine pjefmi
end interface
