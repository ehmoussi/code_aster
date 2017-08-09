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
subroutine thmTherElas(angl_naut, mdal, dalal)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/utbtab.h"
#include "asterfort/matrot.h"
!
real(kind=8), intent(in) :: angl_naut(3)
real(kind=8), intent(out) :: mdal(6)
real(kind=8), intent(out) :: dalal
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Compute thermic quantities
!
! --------------------------------------------------------------------------------------------------
!
! In  angl_naut        : nautical angles
!                        (1) Alpha - clockwise around Z0
!                        (2) Beta  - counterclockwise around Y1
!                        (1) Gamma - clockwise around X
! Out mdal             : product [Elas] {alpha}
! Out dalal            : product <alpha> [Elas] {alpha}
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: al(6), tal(3, 3), talg(3, 3), work(6, 6), pass(3, 3)
    integer :: i,j 
!
! --------------------------------------------------------------------------------------------------
!
    mdal(:)   = 0.d0
    dalal     = 0.d0
    al(:)     = 0.d0
    tal(:,:)  = 0.d0
    talg(:,:) = 0.d0
    work(:,:) = 0.d0
    pass(:,:) = 0.d0
!
! - Get dilatation coefficient
!
    if (ds_thm%ds_material%elas%id .eq. 1) then
        al(1)  = ds_thm%ds_material%ther%alpha
        al(2)  = ds_thm%ds_material%ther%alpha
        al(3)  = ds_thm%ds_material%ther%alpha
    else if (ds_thm%ds_material%elas%id .eq. 3) then
        call matrot(angl_naut, pass)
        tal(1,1) = ds_thm%ds_material%ther%alpha_l
        tal(2,2) = ds_thm%ds_material%ther%alpha_l
        tal(3,3) = ds_thm%ds_material%ther%alpha_n
        al(1) = talg(1,1)
        al(2) = talg(2,2)
        al(3) = talg(3,3)
        al(4) = talg(1,2)
        al(5) = talg(1,3)
        al(6) = talg(2,3)
    else if (ds_thm%ds_material%elas%id .eq. 2) then
        call matrot(angl_naut, pass)
        tal(1,1) = ds_thm%ds_material%ther%alpha_l
        tal(2,2) = ds_thm%ds_material%ther%alpha_t
        tal(3,3) = ds_thm%ds_material%ther%alpha_n
        call utbtab('ZERO', 3, 3, tal, pass, work, talg)
        al(1) = talg(1,1)
        al(2) = talg(2,2)
        al(3) = talg(3,3)
        al(4) = talg(1,2)
        al(5) = talg(1,3)
        al(6) = talg(2,3)
    else
        ASSERT(.false.)
    endif
!
! - Compute
!
    do i = 1, 6
        do j = 1, 6
            mdal(i) = mdal(i) + ds_thm%ds_material%elas%d(i,j)*al(j)
        end do
    end do
    do i = 1, 6
        dalal = dalal+mdal(i)*al(i)
    end do
!
end subroutine
