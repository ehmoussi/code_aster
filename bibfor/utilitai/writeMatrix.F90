! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
subroutine writeMatrix(name, nrows, ncols, l_sym, mat)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/jevech.h"
#include "blas/dcopy.h"
#include "jeveux.h"
!
!
    character(len=*), intent(in)              :: name
    integer, intent(in)                       :: nrows, ncols
    aster_logical, intent(in)                 :: l_sym
    real(kind=8), dimension(:,:), intent(in)  :: mat
!
! --------------------------------------------------------------------------------------------------
!
! IO routine
!
! Write a matrix in memory (zr)
!
! --------------------------------------------------------------------------------------------------
!
!   In name        : name of the matrix read with jevech
!   In nrows/ncols : size of the matrix
!   In l_sym       : the matrix is symmetric ?
!   In mat         : matrix to write
!
! --------------------------------------------------------------------------------------------------
!
    integer :: jv_matr_out, j, ij, i
!
! --------------------------------------------------------------------------------------------------
!
    call jevech(name, 'E', jv_matr_out)
!
    if(l_sym) then
        ASSERT(ncols == nrows)
        do j = 1, ncols
             ij = (j - 1) * j / 2
            call dcopy(j, mat(:,j), 1, zr(jv_matr_out + ij), 1)
        end do
    else
        do j = 1, ncols
            do i = 1, nrows
                ij = j + (i - 1) * ncols
                zr(jv_matr_out + ij -1) = mat(i,j)
            end do
        end do
    end if
!
end subroutine
