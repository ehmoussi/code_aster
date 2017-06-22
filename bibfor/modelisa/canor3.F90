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

subroutine canor3(coor, a, b, c)
    implicit none
#include "asterfort/utmess.h"
    real(kind=8) :: coor(3, *), a, b, c, x1, x2, x3, y1, y2, y3, z1, z2, z3, x12
    real(kind=8) :: y12, z12
    real(kind=8) :: x13, y13, z13, norme
    real(kind=8) :: valr(10)
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    x1=coor(1,1)
    x2=coor(1,2)
    x3=coor(1,3)
    y1=coor(2,1)
    y2=coor(2,2)
    y3=coor(2,3)
    z1=coor(3,1)
    z2=coor(3,2)
    z3=coor(3,3)
    x12=x2-x1
    y12=y2-y1
    z12=z2-z1
    x13=x3-x1
    y13=y3-y1
    z13=z3-z1
    a=y12*z13-y13*z12
    b=x13*z12-x12*z13
    c=x12*y13-x13*y12
    norme  =sqrt(a*a+b*b+c*c)
    if (norme .gt. 0) then
        a=a/norme
        b=b/norme
        c=c/norme
    else
        valr (1) = x1
        valr (2) = y1
        valr (3) = z1
        valr (4) = x2
        valr (5) = y2
        valr (6) = z2
        valr (7) = x3
        valr (8) = y3
        valr (9) = z3
        valr (10) = norme
        call utmess('F', 'MODELISA8_53', nr=10, valr=valr)
    endif
end subroutine
