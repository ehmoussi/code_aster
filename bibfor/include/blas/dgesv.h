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
    subroutine dgesv(n, nrhs, a, lda, ipiv,&
                     b, ldb, info)
        integer, intent(in) :: ldb
        integer, intent(in) :: lda
        integer, intent(in) :: n
        integer, intent(in) :: nrhs
        real(kind=8) ,intent(inout) :: a(lda, *)
        blas_int ,intent(out) :: ipiv(*)
        real(kind=8) ,intent(inout) :: b(ldb, *)
        blas_int, intent(out) :: info
    end subroutine dgesv
end interface
