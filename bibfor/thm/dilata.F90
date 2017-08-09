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
subroutine dilata(angl_naut, phi, tbiot, alphfi)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/matrot.h"
#include "asterfort/utbtab.h"
!
real(kind=8), intent(in) :: angl_naut(3)
real(kind=8), intent(in) :: phi
real(kind=8), intent(in) :: tbiot(6)
real(kind=8), intent(out) :: alphfi
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Compute differential thermal expansion ratio
!
! --------------------------------------------------------------------------------------------------
!
! In  angl_naut        : nautical angles
!                        (1) Alpha - clockwise around Z0
!                        (2) Beta  - counterclockwise around Y1
!                        (1) Gamma - clockwise around X
! In  phi              : current porosity
! In  tbiot            : Biot tensor
! Out alphfi           : differential thermal expansion ratio
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i
    real(kind=8) :: alpha(6)
    real(kind=8), parameter :: kron(6)  = (/1.d0,1.d0,1.d0,0.d0,0.d0,0.d0/)
    real(kind=8) :: talpha(3, 3), talphal(3, 3)
    real(kind=8) :: passag(3, 3), work(3, 3)

!
! --------------------------------------------------------------------------------------------------
!
    alphfi       = 0.d0
    talpha(:,:)  = 0.d0
    talphal(:,:) = 0.d0
    work(:,:)    = 0.d0
    passag(:,:)  = 0.d0
!
! - Get parameters
!
    if (ds_thm%ds_material%elas%id .eq. 1) then
        talpha(1,1) = ds_thm%ds_material%ther%alpha
        talpha(2,2) = ds_thm%ds_material%ther%alpha
        talpha(3,3) = ds_thm%ds_material%ther%alpha
    elseif (ds_thm%ds_material%elas%id .eq. 3) then
        talpha(1,1) = ds_thm%ds_material%ther%alpha_l
        talpha(2,2) = ds_thm%ds_material%ther%alpha_l
        talpha(3,3) = ds_thm%ds_material%ther%alpha_n
    else if (ds_thm%ds_material%elas%id .eq. 2) then
        talpha(1,1) = ds_thm%ds_material%ther%alpha_l
        talpha(2,2) = ds_thm%ds_material%ther%alpha_t
        talpha(3,3) = ds_thm%ds_material%ther%alpha_n
    else
        ASSERT(.false.)
    endif
!
! - Change reference frame
!
    call matrot(angl_naut, passag)
    call utbtab('ZERO', 3, 3, talpha, passag, work, talphal)
!
! - Compute differential thermal expansion ratio
!
    alpha(1) = talphal(1,1)
    alpha(2) = talphal(2,2)
    alpha(3) = talphal(3,3)
    alpha(4) = talphal(1,2)
    alpha(5) = talphal(1,3)
    alpha(6) = talphal(2,3)
!
    do i = 1, 6
        alphfi = alphfi+(tbiot(i)-phi*kron(i))*alpha(i)/3.d0
    enddo
end subroutine
