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
    subroutine possvd(nm, m, n, w, matu,&
                      u, matv, v, eps, rg,&
                      rv1)
        integer :: n
        integer :: nm
        integer :: m
        real(kind=8) :: w(n)
        aster_logical :: matu
        real(kind=8) :: u(nm, n)
        aster_logical :: matv
        real(kind=8) :: v(nm, n)
        real(kind=8) :: eps
        integer :: rg
        real(kind=8) :: rv1(n)
    end subroutine possvd
end interface
