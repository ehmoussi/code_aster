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
    subroutine cast3d(proj, gamma, dh, def, nno,&
                      kpg, nub, nu, dsidep, calbn,&
                      bn, jac, matuu)
        integer :: proj
        real(kind=8) :: gamma(4, 8)
        real(kind=8) :: dh(4, 24)
        real(kind=8) :: def(6, 3, 8)
        integer :: nno
        integer :: kpg
        real(kind=8) :: nub
        real(kind=8) :: nu
        real(kind=8) :: dsidep(6, 6)
        aster_logical :: calbn
        real(kind=8) :: bn(6, 3, 8)
        real(kind=8) :: jac
        real(kind=8) :: matuu(*)
    end subroutine cast3d
end interface
