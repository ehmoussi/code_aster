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
    subroutine dgetv0(ido, bmat, itry, initv, n,&
                      j, v, ldv, resid, rnorm,&
                      ipntr, workd, ierr, alpha)
        integer :: ldv
        integer :: j
        integer :: n
        integer :: ido
        character(len=1) :: bmat
        integer :: itry
        aster_logical :: initv
        real(kind=8) :: v(ldv, j)
        real(kind=8) :: resid(n)
        real(kind=8) :: rnorm
        integer :: ipntr(3)
        real(kind=8) :: workd(2*n)
        integer :: ierr
        real(kind=8) :: alpha
    end subroutine dgetv0
end interface
