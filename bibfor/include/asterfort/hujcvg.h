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
    subroutine hujcvg(nmat, mater, nvi, vind, vinf,&
                      vins, nr, yd, dy, r,&
                      indi, iter, itmax, intg, toler,&
                      bnews, mtrac, ye, lreli, iret)
        integer :: nr
        integer :: nvi
        integer :: nmat
        real(kind=8) :: mater(nmat, 2)
        real(kind=8) :: vind(nvi)
        real(kind=8) :: vinf(nvi)
        real(kind=8) :: vins(nvi)
        real(kind=8) :: yd(nr)
        real(kind=8) :: dy(nr)
        real(kind=8) :: r(nr)
        integer :: indi(7)
        integer :: iter
        integer :: itmax
        integer :: intg
        real(kind=8) :: toler
        aster_logical :: bnews(3)
        aster_logical :: mtrac
        real(kind=8) :: ye(nr)
        aster_logical :: lreli
        integer :: iret
    end subroutine hujcvg
end interface
