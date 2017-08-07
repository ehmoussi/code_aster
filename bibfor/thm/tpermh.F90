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
subroutine tpermh(ndim , angl_naut, aniso, perm_coef,&
                  tperm)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/matrot.h"
#include "asterfort/utbtab.h"
!
integer, intent(in) :: ndim
real(kind=8), intent(in) :: angl_naut(3)
integer, intent(in) :: aniso
real(kind=8), intent(in) :: perm_coef(4)
real(kind=8), intent(out) :: tperm(ndim, ndim)
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Compute permeability tensor
!
! --------------------------------------------------------------------------------------------------
!
! In  ndim             : dimension of space (2 or 3)
! In  angl_naut        : nautical angles
!                        (1) Alpha - clockwise around Z0
!                        (2) Beta  - counterclockwise around Y1
!                        (3) Gamma - clockwise around X
! In  aniso            : type of anisotropy for permeability
!                         0 - Isotropic
!                         1 - Transverse isotropic
!                         2 - Orthotropic
! In  perm_coef        : permeability coefficient
! Out tperm            : permeability tensor
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: perml(3, 3)
    real(kind=8) :: passag(3, 3), work(3, 3), tk2(3, 3)
!
! --------------------------------------------------------------------------------------------------
!
    work(:,:)  = 0.d0
    tk2(:,:)   = 0.d0
    perml(:,:) = 0.d0
    tperm(1:ndim,1:ndim) = 0.d0
!
    if (aniso .eq. 0) then
        tperm(1,1) = perm_coef(1)
        tperm(2,2) = perm_coef(1)
        if (ndim .eq. 3) then
            tperm(3,3) = perm_coef(1)
        endif
    else if (aniso .eq. 1) then
        perml(1,1) = perm_coef(2)
        perml(2,2) = perm_coef(2)
        perml(3,3) = perm_coef(3)
        call matrot(angl_naut, passag)
        call utbtab('ZERO', 3, 3, perml, passag, work, tperm)
    else if (aniso .eq. 2) then
        perml(1,1) = perm_coef(2)
        perml(2,2) = perm_coef(4)
        call matrot(angl_naut, passag)
        call utbtab('ZERO', 3, 3, perml, passag, work, tk2)
        tperm(1,1) = tk2(1,1)
        tperm(2,2) = tk2(2,2)
        tperm(1,2) = tk2(1,2)
        tperm(2,1) = tk2(2,1)
    else
        ASSERT(.false.)
    endif
!
end subroutine
