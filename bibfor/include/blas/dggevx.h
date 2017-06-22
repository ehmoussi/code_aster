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
    subroutine dggevx(balanc, jobvl, jobvr, sense, n,&
                      a, lda, b, ldb, alphar,&
                      alphai, beta, vl, ldvl, vr,&
                      ldvr, ilo, ihi, lscale, rscale,&
                      abnrm, bbnrm, rconde, rcondv, work,&
                      lwork, iwork, bwork, info)
        integer, intent(in) :: ldvr
        integer, intent(in) :: ldvl
        integer, intent(in) :: ldb
        integer, intent(in) :: lda
        character(len=1) ,intent(in) :: balanc
        character(len=1) ,intent(in) :: jobvl
        character(len=1) ,intent(in) :: jobvr
        character(len=1) ,intent(in) :: sense
        integer, intent(in) :: n
        real(kind=8) ,intent(inout) :: a(lda, *)
        real(kind=8) ,intent(inout) :: b(ldb, *)
        real(kind=8) ,intent(out) :: alphar(*)
        real(kind=8) ,intent(out) :: alphai(*)
        real(kind=8) ,intent(out) :: beta(*)
        real(kind=8) ,intent(out) :: vl(ldvl, *)
        real(kind=8) ,intent(out) :: vr(ldvr, *)
        blas_int, intent(out) :: ilo
        blas_int, intent(out) :: ihi
        real(kind=8) ,intent(out) :: lscale(*)
        real(kind=8) ,intent(out) :: rscale(*)
        real(kind=8) ,intent(out) :: abnrm
        real(kind=8) ,intent(out) :: bbnrm
        real(kind=8) ,intent(out) :: rconde(*)
        real(kind=8) ,intent(out) :: rcondv(*)
        real(kind=8) ,intent(out) :: work(*)
        integer, intent(in) :: lwork
        blas_int ,intent(out) :: iwork(*)
        logical(kind=4) ,intent(out) :: bwork(*)
        blas_int, intent(out) :: info
    end subroutine dggevx
end interface
