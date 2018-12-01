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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine mmGetProjection(iresog   , wpg      ,&
                           xpc      , ypc      , xpr      , ypr      , tau1      , tau2      ,&
                           xpc_prev_, ypc_prev_, xpr_prev_, ypr_prev_, tau1_prev_, tau2_prev_)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/jevech.h"
!
integer, intent(in) :: iresog
real(kind=8), intent(out) :: wpg
real(kind=8), intent(out) :: xpc, ypc, xpr, ypr
real(kind=8), intent(out) :: tau1(3), tau2(3)
real(kind=8), optional, intent(out) :: xpc_prev_, ypc_prev_, xpr_prev_, ypr_prev_
real(kind=8), optional, intent(out) :: tau1_prev_(3), tau2_prev_(3)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Get projections datas
!
! --------------------------------------------------------------------------------------------------
!
! In  iresog           : algorithm for geometry
!                        0 - Fixed point
!                        1 - Newton
! Out wpg              : weight for current Gauss point
! Out xpc              : X-coordinate for contact point
! Out ypc              : Y-coordinate for contact point
! Out xpr              : X-coordinate for projection of contact point
! Out ypr              : Y-coordinate for projection of contact point
! Out tau1             : first tangent at current contact point
! Out tau2             : second tangent at current contact point
! Out xpc_prev         : X-coordinate for contact point (previous iteration)
! Out ypc_prev         : Y-coordinate for contact point (previous iteration)
! Out xpr_prev         : X-coordinate for projection of contact point (previous iteration)
! Out ypr_prev         : Y-coordinate for projection of contact point (previous iteration)
! Out tau1_prev        : first tangent at current contact point (previous iteration)
! Out tau2_prev        : second tangent at current contact point (previous iteration)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: jpcf
    real(kind=8) :: xpc_prev, ypc_prev, xpr_prev, ypr_prev
    real(kind=8) :: tau1_prev(3), tau2_prev(3)
!
! --------------------------------------------------------------------------------------------------
!
    call jevech('PCONFR', 'L', jpcf)
!
    xpc = zr(jpcf-1+1)
    ypc = zr(jpcf-1+2)
    xpr = zr(jpcf-1+3)
    ypr = zr(jpcf-1+4)
    tau1(1) = zr(jpcf-1+5)
    tau1(2) = zr(jpcf-1+6)
    tau1(3) = zr(jpcf-1+7)
    tau2(1) = zr(jpcf-1+8)
    tau2(2) = zr(jpcf-1+9)
    tau2(3) = zr(jpcf-1+10)
    wpg = zr(jpcf-1+11)
!
    if (iresog .eq. 0) then
        xpc_prev = zr(jpcf-1+1)
        ypc_prev = zr(jpcf-1+2)
        xpr_prev = zr(jpcf-1+3)
        ypr_prev = zr(jpcf-1+4)
    else
        xpc_prev = zr(jpcf-1+38)
        ypc_prev = zr(jpcf-1+39)
        xpr_prev = zr(jpcf-1+40)
        ypr_prev = zr(jpcf-1+41)
    endif
    tau1_prev(1) = zr(jpcf-1+32)
    tau1_prev(2) = zr(jpcf-1+33)
    tau1_prev(3) = zr(jpcf-1+34)
    tau2_prev(1) = zr(jpcf-1+35)
    tau2_prev(2) = zr(jpcf-1+36)
    tau2_prev(3) = zr(jpcf-1+37)
!
    if (present(tau1_prev_)) tau1_prev_ = tau1_prev
    if (present(tau2_prev_)) tau2_prev_ = tau2_prev
    if (present(xpc_prev_)) xpc_prev_ = xpc_prev
    if (present(ypc_prev_)) ypc_prev_ = ypc_prev
    if (present(xpr_prev_)) xpr_prev_ = xpr_prev
    if (present(ypr_prev_)) ypr_prev_ = ypr_prev
!
end subroutine
