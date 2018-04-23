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
!
subroutine nmepsi(ndim, nno, l_axi, l_large, vff,&
                  r, dfdi, disp, f, epsi_)
!
implicit none
!
#include "asterf_types.h"
#include "blas/daxpy.h"
#include "blas/dcopy.h"
#include "blas/ddot.h"
!
aster_logical, intent(in) :: l_axi, l_large
integer, intent(in) :: ndim, nno
real(kind=8), intent(in) :: vff(nno), r, dfdi(nno, ndim), disp(ndim, nno)
real(kind=8), intent(out) :: f(3, 3)
real(kind=8), optional, intent(out) :: epsi_(6)
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computations
!
! Compute strains at current Gauss point
!
! --------------------------------------------------------------------------------------------------
!
! In  ndim             : dimension of space (2 or 3)
! In  nno              : number of nodes
! In  l_axi            : .true. for axi-symetric model
! In  l_large          : .true. for large strains
! In  vff              : shape functions at current Gauss point
! In  r                : radius of current Gauss point (for axi-symmetric)
! In  dfdi             : derivative of shape functions (matrix [B]) at current Gauss point
! In  disp             : displacements at nodes of current element
! Out f                : transformation gradient F = 1 + Grad(U) (identity if small strains)
! Out epsi             : small strains vector
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i, j
    real(kind=8) :: grad(3, 3), ur
    real(kind=8), parameter :: r2 = sqrt(2.d0)/2.d0
    real(kind=8), parameter :: unity(9) = (/1.d0, 0.d0, 0.d0, 0.d0, 1.d0, 0.d0, 0.d0, 0.d0, 1.d0/)
    real(kind=8) :: kron(3,3) = reshape(unity, (/3,3/))
!
! --------------------------------------------------------------------------------------------------
!
    grad(:,:) = 0.d0
!
! - Gradient Grad(U)
!
    do i = 1, ndim
        do j = 1, ndim
            grad(i,j) = ddot(nno, dfdi(1,j), 1, disp(i,1), ndim)
        end do
    end do
!
! - Radial displacement
!
    if (l_axi) then
        ur = ddot(nno, vff, 1, disp, ndim)
    endif
!
! - Compute transformation gradient F = 1 + Grad(U)
!
    call dcopy(9, kron, 1, f, 1)
    if (l_large) then
        call daxpy(9, 1.d0, grad, 1, f, 1)
        if (l_axi) then 
            f(3,3) = f(3,3) + ur/r
        endif
    endif
!
! - Compute small strains
!
    if (present(epsi_)) then
        epsi_(:) = 0.d0
        epsi_(1) = grad(1,1)
        epsi_(2) = grad(2,2)
        epsi_(3) = 0.d0
        epsi_(4) = r2*(grad(1,2)+grad(2,1))
        if (l_axi) then
            epsi_(3) = ur/r
        endif
        if (ndim .eq. 3) then
            epsi_(3) = grad(3,3)
            epsi_(5) = r2*(grad(1,3)+grad(3,1))
            epsi_(6) = r2*(grad(2,3)+grad(3,2))
        endif
    endif
!
end subroutine
