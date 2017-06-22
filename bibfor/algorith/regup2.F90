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

subroutine regup2(x0, y0, y0p, y1, a,&
                  b, c)
!
! REGUP2 :
!  CALCULE UN  POLYNOME P DU SECOND DEGRE TEL QUE
!  P(X)=AX**2 +BX +C
!  P(X0)=Y0, DPDX(X0)=Y0P, P(1)=Y1
    implicit none
    real(kind=8) :: x0, y0, y0p, y1, a, b, c
!
    a=(y1-y0+y0p*(x0-1.d0))/((1.d0-x0)**2)
    b= -2.d0*a*x0 + y0p
    c = y1 - a - b
end subroutine
