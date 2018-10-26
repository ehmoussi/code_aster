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
subroutine mmmmpb(rese, nrese, ndim, matprb)
!
implicit none
!
#include "asterc/r8prem.h"
#include "asterfort/assert.h"
!
real(kind=8), intent(in) :: rese(3), nrese
integer, intent(in) :: ndim
real(kind=8), intent(out) :: matprb(3, 3)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Compute projection matrix
!
! --------------------------------------------------------------------------------------------------
!
! In  ndim             : dimension of problem (2 or 3)
! In  rese             : Lagrange (semi) multiplier for friction
! In  nrese            : norm of Lagrange (semi) multiplier for friction
! Out matrpb           : projection matrix K(x) = (Id-x*xt/!!x!!**)1/!!x!!
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: norme, theta
    integer :: i, j
!
! --------------------------------------------------------------------------------------------------
!
    matprb(:,:) = 0.d0
    theta = 1.d0
    ASSERT(nrese .gt. r8prem())
!
! - Compute LAMBDA +RHO[[U]]_TAU norm
!
    norme = nrese*nrese
!
! - Compute matrix
!
    do i = 1, ndim
        do j = 1, ndim
            matprb(i,j) = -theta*rese(i)*rese(j)/norme
        end do
    end do
    do j = 1, ndim
        matprb(j,j) = 1.d0+matprb(j,j)
    end do
    do i = 1, ndim
        do j = 1, ndim
            matprb(i,j) = matprb(i,j)/nrese
        end do
    end do
!
end subroutine
