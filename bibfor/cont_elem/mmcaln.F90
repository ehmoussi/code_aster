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
subroutine mmcaln(ndim, tau1  , tau2  ,&
                  norm, mprojn, mprojt)
!
implicit none
!
#include "asterc/r8prem.h"
#include "asterfort/assert.h"
#include "asterfort/mmnorm.h"
!
integer, intent(in) :: ndim
real(kind=8), intent(in) :: tau1(3), tau2(3)
real(kind=8), intent(out) :: norm(3), mprojn(3, 3), mprojt(3, 3)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Compute local basis
!
! --------------------------------------------------------------------------------------------------
!
! In  ndim             : dimension of problem (2 or 3)
! In  tau1             : first tangent at current contact point
! In  tau2             : second tangent at current contact point
! Out norm             : normal at current contact point
! Out mprojn           : matrix of normal projection
! Out mprojt           : matrix of tangent projection
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i, j
    real(kind=8) :: noor
!
! --------------------------------------------------------------------------------------------------
!
    mprojt(:,:) = 0.d0
    mprojn(:,:) = 0.d0
    norm(:)    = 0.d0
!
! - Compute normal
!
    call mmnorm(ndim, tau1, tau2, norm, noor)
    if (noor .le. r8prem()) then
        ASSERT(ASTER_FALSE)
    endif
!
! - Matrix of normal projection
!
    do i = 1, ndim
        do j = 1, ndim
            mprojn(i,j) = norm(i)*norm(j)
        end do
    end do
!
! - Matrix of tangent projection
!
    do i = 1, ndim
        do j = 1, ndim
            mprojt(i,j) = -1.d0*norm(i)*norm(j)
        end do
    end do
    do i = 1, ndim
        mprojt(i,i) = 1.d0 + mprojt(i,i)
    end do
!
end subroutine
