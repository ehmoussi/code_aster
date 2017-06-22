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

interface
    subroutine dgesvx(fact, trans, n, nrhs, a,&
                      lda, af, ldaf, ipiv, equed,&
                      r, c, b, ldb, x,&
                      ldx, rcond, ferr, berr, work,&
                      iwork, info)
        integer, intent(in) :: ldx
        integer, intent(in) :: ldb
        integer, intent(in) :: ldaf
        integer, intent(in) :: lda
        character(len=1) ,intent(in) :: fact
        character(len=1) ,intent(in) :: trans
        integer, intent(in) :: n
        integer, intent(in) :: nrhs
        real(kind=8) ,intent(inout) :: a(lda, *)
        real(kind=8) ,intent(inout) :: af(ldaf, *)
        blas_int ,intent(inout) :: ipiv(*)
        character(len=1) ,intent(inout) :: equed
        real(kind=8) ,intent(inout) :: r(*)
        real(kind=8) ,intent(inout) :: c(*)
        real(kind=8) ,intent(inout) :: b(ldb, *)
        real(kind=8) ,intent(out) :: x(ldx, *)
        real(kind=8) ,intent(out) :: rcond
        real(kind=8) ,intent(out) :: ferr(*)
        real(kind=8) ,intent(out) :: berr(*)
        real(kind=8) ,intent(out) :: work(*)
        blas_int ,intent(out) :: iwork(*)
        blas_int, intent(out) :: info
    end subroutine dgesvx
end interface
