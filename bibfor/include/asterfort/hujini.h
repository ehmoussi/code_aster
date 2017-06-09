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
    subroutine hujini(mod, nmat, mater, intg, deps,&
                      nr, yd, nvi, vind, sigd,&
                      sigf, bnews, mtrac, dy, indi,&
                      iret)
        integer :: nvi
        integer :: nmat
        character(len=8) :: mod
        real(kind=8) :: mater(nmat, 2)
        integer :: intg
        real(kind=8) :: deps(6)
        integer :: nr
        real(kind=8) :: yd(18)
        real(kind=8) :: vind(nvi)
        real(kind=8) :: sigd(6)
        real(kind=8) :: sigf(6)
        aster_logical :: bnews(3)
        aster_logical :: mtrac
        real(kind=8) :: dy(18)
        integer :: indi(7)
        integer :: iret
    end subroutine hujini
end interface
