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

subroutine tpsivp_shb(mp, sigmav, shtwf2)
    implicit none
!
! Transformation P SIgma V P 
!
!
! Transform Sigma in vector form (6 components) using given transformation
! matrix
!                         sigmao <- mp^T * sigmai * mp
! If shtwf2 is false, 6 components are expressed as: XX  YY  ZZ   XY   XZ   YZ
! If shtwf2 is false, 6 components are expressed as: XX  YY  ZZ  2XY  2XZ  2YZ 
!
! IN  mp          (3,3) transformation matrix
! INOUT  sigmav  Stress or strain vector (6 components)
! IN  shtwf2      True if tpsivp has to handle factor 2 on shear terms
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "blas/dgemm.h"
#include "blas/dsymm.h"
!
    real(kind=8), dimension(3,3), intent(in) :: mp
    real(kind=8), dimension(6), intent(inout) :: sigmav
    aster_logical, intent(in) :: shtwf2
!
    integer :: ld
    real(kind=8) :: alpha, beta
    real(kind=8), dimension(3,3) :: sigma, temp
!
! ......................................................................
!
    ASSERT(size(mp,1)==3)
!
!   Expressing stress/strain tensor in a full symmetric matrix 'L'  
    sigma(:,:) = 0.d0
    sigma(1,1) = sigmav(1)
    sigma(2,2) = sigmav(2)
    sigma(3,3) = sigmav(3)
!
    if (shtwf2) then
       sigma(2,1) = 0.5d0*sigmav(4)
       sigma(3,1) = 0.5d0*sigmav(5)
       sigma(3,2) = 0.5d0*sigmav(6)
    else
       sigma(2,1) = sigmav(4)
       sigma(3,1) = sigmav(5)
       sigma(3,2) = sigmav(6)
    endif
!
! temp = sigma*mp
    ld=3
    alpha = 1.d0
    beta = 0.d0
    call dsymm('L', 'L', ld, ld, alpha,&
               sigma, ld, mp, ld, beta,&
               temp, ld)
! sigma <- mp^T*temp
    call dgemm('T', 'N', 3, 3, 3,&
               alpha, mp, 3, temp, 3,&
               beta, sigma(1,1), 3)
!
!   Expressing stress/strain back in vector form
! xx
    sigmav(1) = sigma(1,1)
! yy
    sigmav(2) = sigma(2,2)
! zz
    sigmav(3) = sigma(3,3)
!
    if (shtwf2) then
! xy
       sigmav(4) = 2.0d0*sigma(2,1)
! xz
       sigmav(5) = 2.0d0*sigma(3,1)
! yz
       sigmav(6) = 2.0d0*sigma(3,2)
    else
! xy
       sigmav(4) = sigma(2,1)
! xz
       sigmav(5) = sigma(3,1)
! yz
       sigmav(6) = sigma(3,2)
    endif
!
end subroutine 
