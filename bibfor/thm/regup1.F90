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
subroutine regup1(x0, y0, y0p,&
                  a , b)
!
implicit none
!
real(kind=8), intent(in) :: x0, y0, y0p
real(kind=8), intent(out) :: a, b
!
! --------------------------------------------------------------------------------------------------
!
! THM - Permeability
!
! Regularization with linear polynom - Get coefficients of polynom
!
! --------------------------------------------------------------------------------------------------
!
! For polynom p=ax+b with p(x0) = y0 and dp_dx(x0) = y0p
!
! --------------------------------------------------------------------------------------------------
!
    a = y0p
    b = y0-y0p*x0
!
end subroutine
