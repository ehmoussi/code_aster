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
    subroutine hujjac(mod, nmat, mater, indi, deps,&
                      nr, yd, yf, ye, nvi,&
                      vind, vins, vinf, drdy, bnews,&
                      mtrac, iret)
        integer :: nvi
        integer :: nr
        integer :: nmat
        character(len=8) :: mod
        real(kind=8) :: mater(nmat, 2)
        integer :: indi(7)
        real(kind=8) :: deps(6)
        real(kind=8) :: yd(nr)
        real(kind=8) :: yf(nr)
        real(kind=8) :: ye(nr)
        real(kind=8) :: vind(nvi)
        real(kind=8) :: vins(nr)
        real(kind=8) :: vinf(nvi)
        real(kind=8) :: drdy(nr, nr)
        aster_logical :: bnews(3)
        aster_logical :: mtrac
        integer :: iret
    end subroutine hujjac
end interface
