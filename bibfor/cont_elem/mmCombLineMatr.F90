! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine mmCombLineMatr(alpha_cont, matr_prev, matr)
!
implicit none
!
real(kind=8), intent(in) :: alpha_cont
real(kind=8), intent(in) :: matr_prev(81,81)
real(kind=8), intent(inout) :: matr(81,81)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Linear combination of matrices
!
! --------------------------------------------------------------------------------------------------
!
! In  alpha_cont       : ratio for linear combination of matrix (contact)
! In  matr_prev        : matrix at previous Newton iteration
! IO  matr             : matrix 
!
! --------------------------------------------------------------------------------------------------
!
    integer :: count_consi
    real(kind=8) :: matr_tmp(81, 81), coef
!
! --------------------------------------------------------------------------------------------------
!
    matr_tmp    = alpha_cont*matr+(1-alpha_cont)*matr_prev
    count_consi = 0
    51 continue
    count_consi = count_consi+1
    coef        = 0.5*(alpha_cont+1.0)
    matr_tmp    = coef*matr+(1.0-coef)*matr_prev
    if (norm2(matr_tmp-matr) &
        .gt. 1.d-6*norm2(matr) .and. count_consi .le. 15) then 
       goto 51
    elseif ( norm2(matr_tmp-matr) .lt. 1.d-6*norm2(matr)) then 
       matr = matr_tmp
    else 
       matr = 0.9999d0*matr + 0.0001d0*matr_tmp
    endif
!
end subroutine
