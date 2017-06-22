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
    subroutine dneupd(rvec, howmny, select, dr, di,&
                      z, ldz, sigmar, sigmai, workev,&
                      bmat, n, which, nev, tol,&
                      resid, ncv, v, ldv, iparam,&
                      ipntr, workd, workl, lworkl, info)
        integer :: lworkl
        integer :: ldv
        integer :: ncv
        integer :: nev
        integer :: n
        integer :: ldz
        aster_logical :: rvec
        character(len=1) :: howmny
        aster_logical :: select(ncv)
        real(kind=8) :: dr(nev+1)
        real(kind=8) :: di(nev+1)
        real(kind=8) :: z(ldz, *)
        real(kind=8) :: sigmar
        real(kind=8) :: sigmai
        real(kind=8) :: workev(3*ncv)
        character(len=1) :: bmat
        character(len=2) :: which
        real(kind=8) :: tol
        real(kind=8) :: resid(n)
        real(kind=8) :: v(ldv, ncv)
        integer :: iparam(11)
        integer :: ipntr(14)
        real(kind=8) :: workd(3*n)
        real(kind=8) :: workl(lworkl)
        integer :: info
    end subroutine dneupd
end interface
