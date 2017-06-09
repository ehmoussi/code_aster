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
    subroutine dxdmul(lcalct, icou, iniv, t1ve, t2ui,&
                      h, d1i, d2i, x3i, epi)
        aster_logical :: lcalct
        integer :: icou
        integer :: iniv
        real(kind=8) :: t1ve(3, 3)
        real(kind=8) :: t2ui(2, 2)
        real(kind=8) :: h(3, 3)
        real(kind=8) :: d1i(2, 2)
        real(kind=8) :: d2i(2, 4)
        real(kind=8) :: x3i
        real(kind=8) :: epi
    end subroutine dxdmul
end interface
