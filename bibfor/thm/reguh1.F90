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

subroutine reguh1(x0, y0, y0p,&
                  b, c)
!
!
implicit none
!
    real(kind=8), intent(in) :: x0, y0, y0p
    real(kind=8), intent(out) :: b, c
!
! --------------------------------------------------------------------------------------------------
!
! THM - Saturation
!
! Regularization by first order hyperbola
!
! --------------------------------------------------------------------------------------------------
!
!  Y(X)  = 1-B/(C-X) with Y(X0) = Y0 and DYDX(X0)=Y0P
!
! --------------------------------------------------------------------------------------------------
!
    b=-((1.d0-y0)**2.d0)/y0p
    c= x0-(1.d0-y0)/y0p
!
end subroutine
