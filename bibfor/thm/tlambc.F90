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
subroutine tlambc(angl_naut, ndim, tlamct)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/matrot.h"
#include "asterfort/utbtab.h"
#include "asterfort/THM_type.h"
!
real(kind=8), intent(in) :: angl_naut(3)
integer, intent(in) :: ndim
real(kind=8), intent(out) :: tlamct(ndim, ndim)
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Compute tensor of thermal conductivity (constant part)
!
! --------------------------------------------------------------------------------------------------
!
! In  angl_naut        : nautical angles
!                        (1) Alpha - clockwise around Z0
!                        (2) Beta  - counterclockwise around Y1
!                        (1) Gamma - clockwise around X
! In  ndim             : dimension of space
! Out tlamct           : tensor of thermal conductivity (constant part)
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: tlamcti(3, 3), passag(3, 3), work(3, 3), tk2(3, 3)
!
! --------------------------------------------------------------------------------------------------
!
    work(:,:)    = 0.d0
    passag(:,:)  = 0.d0
    tlamcti(:,:) = 0.d0
    tk2(:,:)     = 0.d0
    tlamct(:,:)  = 0.d0
!
    if (ds_thm%ds_material%ther%cond_type .eq. THER_COND_ISOT) then
        tlamct(1,1) = ds_thm%ds_material%ther%lambda_ct
        tlamct(2,2) = ds_thm%ds_material%ther%lambda_ct
        if (ndim .eq. 3) then
            tlamct(3,3) = ds_thm%ds_material%ther%lambda_ct
        endif
    else if (ds_thm%ds_material%ther%cond_type .eq. THER_COND_ISTR) then
        tlamcti(1,1) = ds_thm%ds_material%ther%lambda_ct_l
        tlamcti(2,2) = ds_thm%ds_material%ther%lambda_ct_l
        tlamcti(3,3) = ds_thm%ds_material%ther%lambda_ct_n
        if (ndim .eq. 3) then
            call matrot(angl_naut, passag)
            call utbtab('ZERO', 3, 3, tlamcti, passag, work, tk2)
            tlamct = tk2
        endif
    else if (ds_thm%ds_material%ther%cond_type .eq. THER_COND_ORTH) then
        tlamcti(1,1) = ds_thm%ds_material%ther%lambda_ct_l
        tlamcti(2,2) = ds_thm%ds_material%ther%lambda_ct_t
        call matrot(angl_naut, passag)
        call utbtab('ZERO', 3, 3, tlamcti, passag, work, tk2)
        tlamct(1,1) = tk2(1,1)
        tlamct(2,2) = tk2(2,2)
        tlamct(1,2) = tk2(1,2)
        tlamct(2,1) = tk2(2,1)
    else
! ----- No thermic
    endif
!
end subroutine
