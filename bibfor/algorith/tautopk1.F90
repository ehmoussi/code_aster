! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
subroutine tautopk1(ndim, tau, F, PK1)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/mat_inv.h"
!
    integer, intent(in)                         :: ndim
    real(kind=8), dimension(6), intent(in)      :: tau
    real(kind=8), dimension(3,3), intent(in)    :: F
    real(kind=8), dimension(3,3), intent(out)   :: PK1
! --------------------------------------------------------------------------------------------------
! Conversion of Kirshoff stress tensor to the first Piola-Kirshoff stress tensor
! PK1 = F^-1 * tau * F^-T
!
! In ndim: dimension of tthe problem ( 2 or 3)
! In tau : the Kirshoff stress tensor (S11, S22, S33, rac2*S12, rac2*S13, rac2*S23)
! In F   : gradient of the deformation
! Out PK1: the first Piola-Kirshoff stress tensor
! --------------------------------------------------------------------------------------------------
!
    real(kind=8), parameter :: rac2 = sqrt(2.d0)
    real(kind=8), dimension(3,3) :: Taumat, Finv, TMP
!
    Taumat(1,1) = Tau(1)
    Taumat(2,2) = Tau(2)
    Taumat(3,3) = Tau(3)
!
    Taumat(1,2) = Tau(4) / rac2
    Taumat(2,1) = Taumat(1,2)
!
    if (ndim == 2) then
        Taumat(3,1:2) = 0.d0
        Taumat(1:2,3) = 0.d0
    elseif (ndim == 3) then
        Taumat(1,3) = Tau(5) / rac2
        Taumat(3,1) = Taumat(1,3)
!
        Taumat(2,3) = Tau(6) / rac2
        Taumat(3,2) = Taumat(2,3)
    else
        ASSERT(ASTER_FALSE)
    end if
!
    Finv = mat_inv(3, F)
    TMP = matmul(Taumat, transpose(Finv))
    PK1 = matmul(Finv, TMP)
!
end subroutine
