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
    subroutine rgilin3d(xmat, nmat, var0, varf, nvari,&
                        dt, depst, nstrs, sigf, mfr,&
                        errb3d, teta1, teta2, fl3d, ifour,&
                        istep)
#include "asterf_types.h"
        integer :: nstrs
        integer :: nvari
        integer :: nmat
        real(kind=8) :: xmat(nmat)
        real(kind=8) :: var0(nvari)
        real(kind=8) :: varf(nvari)
        real(kind=8) :: dt
        real(kind=8) :: depst(nstrs)
        real(kind=8) :: sigf(nstrs)
        integer :: mfr
        integer :: errb3d
        real(kind=8) :: teta1
        real(kind=8) :: teta2
        aster_logical :: fl3d
        integer :: ifour
        integer :: istep
    end subroutine rgilin3d
end interface 
