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
!
#include "asterf_types.h"
!
interface
    subroutine mmGetProjection(iresog   , wpg      ,&
                               xpc      , ypc      , xpr      , ypr      , tau1      , tau2      ,&
                               xpc_prev_, ypc_prev_, xpr_prev_, ypr_prev_, tau1_prev_, tau2_prev_)
        integer, intent(in) :: iresog
        real(kind=8), intent(out) :: wpg
        real(kind=8), intent(out) :: xpc, ypc, xpr, ypr
        real(kind=8), intent(out) :: tau1(3), tau2(3)
        real(kind=8), optional, intent(out) :: xpc_prev_, ypc_prev_, xpr_prev_, ypr_prev_
        real(kind=8), optional, intent(out) :: tau1_prev_(3), tau2_prev_(3)
    end subroutine mmGetProjection
end interface
