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
    subroutine dorm2r(side, trans, m, n, k,&
                      a, lda, tau, c, ldc,&
                      work, info)
        integer, intent(in) :: ldc
        integer, intent(in) :: lda
        character(len=1) ,intent(in) :: side
        character(len=1) ,intent(in) :: trans
        integer, intent(in) :: m
        integer, intent(in) :: n
        integer, intent(in) :: k
        real(kind=8) ,intent(in) :: a(lda, *)
        real(kind=8) ,intent(in) :: tau(*)
        real(kind=8) ,intent(inout) :: c(ldc, *)
        real(kind=8) ,intent(out) :: work(*)
        blas_int, intent(out) :: info
    end subroutine dorm2r
end interface
