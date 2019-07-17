! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
    subroutine dsyrk(uplo, trans, n, k, alpha, a, lda, beta, c, ldc)
!
        character(len=1), intent(in) :: uplo
        character(len=1), intent(in) :: trans
        integer, intent(in) :: n
        integer, intent(in) :: k
        integer, intent(in) :: lda
        integer, intent(in) :: ldc
        real(kind=8), intent(in) :: alpha
        real(kind=8), intent(in) :: beta
        real(kind=8), intent(in) :: a(lda, *)
        real(kind=8), intent(inout) :: c(ldc, *)
!
    end subroutine dsyrk
end interface
