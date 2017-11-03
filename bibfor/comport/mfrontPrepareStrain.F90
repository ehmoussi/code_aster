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
subroutine mfrontPrepareStrain(l_large_strain, l_pred, l_czm,&
                               neps          , epsm  , deps ,&
                               epsth         , depsth,&
                               stran         , dstran,&
                               detf_)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/pmat.h"
#include "asterfort/r8inir.h"
#include "asterfort/lcdetf.h"
#include "blas/daxpy.h"
#include "blas/dcopy.h"
#include "blas/dscal.h"
!
aster_logical, intent(in) :: l_large_strain
aster_logical, intent(in) :: l_pred, l_czm
integer, intent(in) :: neps
real(kind=8), intent(in) :: epsm(6), deps(6)
real(kind=8), intent(in) :: epsth(neps), depsth(neps)
real(kind=8), intent(out) :: stran(9), dstran(9)
real(kind=8), optional, intent(out) :: detf_
!
! --------------------------------------------------------------------------------------------------
!
! Behaviour (MFront)
!
! Prepare strains
!
! --------------------------------------------------------------------------------------------------
!
! In  l_large_strain   : .true. if large strains
! In  l_pred           : .true. of prediction (first Newton's iteration)
! In  l_czm            : .true. if cohesive zone model
! In  neps             : number of components of strains
! In  epsm             : strains at beginning of current step time
! In  deps             : increment of strains during current step time
! In  epsth            : thermic strains at beginning of current step time
! In  depsth           : increment of thermic strains during current step time
! Out stran            : tensor of strains at beginning of current step time for MFront
! Out dstran           : increment of tensor of strains during current step time for MFront
! Out detf             : determinant of gradient
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8), parameter :: rac2 = sqrt(2.d0)
    real(kind=8) :: dfgrd0(3, 3), dfgrd1(3, 3)
!
! --------------------------------------------------------------------------------------------------
!
    stran(:)  = 0.d0
    dstran(:) = 0.d0
!
    if (l_large_strain) then
        ASSERT(neps .eq. 9)
        dfgrd0(:,:) = 0.d0
        dfgrd1(:,:) = 0.d0
        call dcopy(neps, epsm, 1, dfgrd0, 1)
        if (l_pred) then
            call dcopy(neps, dfgrd0, 1, dfgrd1, 1)
        else
            call pmat(3, deps, dfgrd0, dfgrd1)
        endif
        call dcopy(neps, dfgrd0, 1, stran, 1)
        call dcopy(neps, dfgrd1, 1, dstran, 1)
        call lcdetf(3, dfgrd1, detf_)
    else
        ASSERT(neps .ne. 9)
        if ((neps .eq. 6) .or. (neps .eq. 4)) then
            if (l_pred) then
                call r8inir(6, 0.d0, dstran, 1)
            else
                call dcopy(neps, deps, 1, dstran, 1)
                call daxpy(neps, -1.d0, depsth, 1, dstran,1)
                call dscal(3, rac2, dstran(4), 1) 
            endif
            call dcopy(neps, epsm, 1, stran, 1)
            call daxpy(neps, -1.d0, epsth, 1, stran, 1)
            call dscal(3, rac2, stran(4), 1)
        else if ( (neps .eq. 3) .and. l_czm) then
            if (l_pred) then
                call r8inir(neps, 0.d0, dstran, 1)
            else
                call dcopy(neps, deps, 1, dstran, 1)
            endif
            call dcopy(neps, epsm, 1, stran, 1)
        else
            ASSERT(.false.)
        endif
    endif
!
end subroutine
