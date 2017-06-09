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
    subroutine zneupd(rvec, howmny, select, d, z,&
                      ldz, sigma, workev, bmat, n,&
                      which, nev, tol, resid, ncv,&
                      v, ldv, iparam, ipntr, workd,&
                      workl, lworkl, rwork, info)
        integer :: lworkl
        integer :: ldv
        integer :: ncv
        integer :: n
        integer :: ldz
        aster_logical :: rvec
        character(len=1) :: howmny
        aster_logical :: select(*)
        complex(kind=8) :: d(*)
        complex(kind=8) :: z(ldz, *)
        complex(kind=8) :: sigma
        complex(kind=8) :: workev(2*ncv)
        character(len=1) :: bmat
        character(len=2) :: which
        integer :: nev
        real(kind=8) :: tol
        complex(kind=8) :: resid(*)
        complex(kind=8) :: v(ldv, *)
        integer :: iparam(11)
        integer :: ipntr(14)
        complex(kind=8) :: workd(3*n)
        complex(kind=8) :: workl(lworkl)
        real(kind=8) :: rwork(*)
        integer :: info
    end subroutine zneupd
end interface
