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

subroutine tebiot(angl_naut, tbiot)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterc/r8dgrd.h"
#include "asterc/r8pi.h"
#include "asterfort/assert.h"
#include "asterfort/matrot.h"
#include "asterfort/utbtab.h"
#include "asterfort/THM_type.h"
!
real(kind=8), intent(in) :: angl_naut(3)
real(kind=8), intent(out) :: tbiot(6)
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Compute Biot tensor
!
! --------------------------------------------------------------------------------------------------
!
! In  angl_naut        : nautical angles
!                        (1) Alpha - clockwise around Z0
!                        (2) Beta  - counterclockwise around Y1
!                        (1) Gamma - clockwise around X
! Out tbiot            : Biot tensor
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: bt(3, 3), work(3, 3)
    real(kind=8) :: pass(3, 3), bgl(3, 3)
!
! --------------------------------------------------------------------------------------------------
!
    bt(:,:)    = 0.d0
    pass(:,:)  = 0.d0
    work(:,:)  = 0.d0
    bgl(:,:)   = 0.d0
    tbiot(:)   = 0.d0
!
! - Local tensor
!
    if (ds_thm%ds_material%biot_type .eq. BIOT_TYPE_ISOT) then
        bt(1,1) = ds_thm%ds_material%biot_coef
        bt(2,2) = ds_thm%ds_material%biot_coef
        bt(3,3) = ds_thm%ds_material%biot_coef
    else if (ds_thm%ds_material%biot_type .eq. BIOT_TYPE_ISTR) then
        bt(1,1) = ds_thm%ds_material%biot_l
        bt(2,2) = ds_thm%ds_material%biot_l
        bt(3,3) = ds_thm%ds_material%biot_n
    else if (ds_thm%ds_material%biot_type .eq. BIOT_TYPE_ORTH) then
        bt(1,1) = ds_thm%ds_material%biot_l
        bt(2,2) = ds_thm%ds_material%biot_t
        bt(3,3) = ds_thm%ds_material%biot_n
    else
        ASSERT(.false.)
    endif
!
! - Construct transition matrix from nautical angles
!
    call matrot(angl_naut, pass)
!
! - Change reference frame
!
    call utbtab('ZERO', 3, 3, bt, pass, work, bgl)
!
! - Transform in vector
!
    tbiot(1) = bgl(1,1)
    tbiot(2) = bgl(2,2)
    tbiot(3) = bgl(3,3)
    tbiot(4) = bgl(1,2)
    tbiot(5) = bgl(1,3)
    tbiot(6) = bgl(2,3)
!
end subroutine
