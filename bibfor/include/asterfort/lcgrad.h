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

#include "asterf_types.h"
!
interface
    subroutine lcgrad(resi, rigi, sig, apg, lag, grad, aldc,&
                  r, c, deps_sig,dphi_sig,deps_a,dphi_a, sief, dsde)
        aster_logical :: resi, rigi
        real(kind=8),intent(in) :: sig(:), apg, lag, grad(:), aldc, r, c
        real(kind=8),intent(in) :: deps_sig(:,:),dphi_sig(:),deps_a(:),dphi_a
        real(kind=8)            :: sief(*), dsde(:,:)
    end subroutine lcgrad
end interface
