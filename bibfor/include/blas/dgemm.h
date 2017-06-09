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
    subroutine dgemm(transa, transb, m, n, k,&
                     alpha, a, lda, b, ldb,&
                     beta, c, ldc)
        integer, intent(in) :: ldc
        integer, intent(in) :: ldb
        integer, intent(in) :: lda
        character(len=1) ,intent(in) :: transa
        character(len=1) ,intent(in) :: transb
        integer, intent(in) :: m
        integer, intent(in) :: n
        integer, intent(in) :: k
        real(kind=8) ,intent(in) :: alpha
        real(kind=8) ,intent(in) :: a(lda, *)
        real(kind=8) ,intent(in) :: b(ldb, *)
        real(kind=8) ,intent(in) :: beta
        real(kind=8) ,intent(inout) :: c(ldc, *)
    end subroutine dgemm
end interface
