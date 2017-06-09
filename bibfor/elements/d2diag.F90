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

subroutine d2diag(a, d, s, theta)
!
    implicit  none
!
!     CALCUL DE LA MATRICE DIAGONALE D UNE MATRICE 2x2
!
! IN  A : MATRICE 2x2 A DIAGONALISER
!
! OUT D : MATRICE DIAGONALISER
! OUT S : MATRICE DE PASSAGE
! OUT THETA : ANGLE DE ROTATION
!
#include "asterfort/di2epx.h"
    real(kind=8) :: zero, a(2, 2), d(2), s(2, 2), theta, b(3), aux
    real(kind=8) :: aux1
!
    aux1 = 1.d0
    zero = 1.d-10
!
    b(1)=a(1,1)
    b(2)=a(2,2)
    b(3)=a(1,2)
!
!     CALCUL DE LA MATRICE DIAGONALISEE D DE B
    call di2epx(b, d)
!
    if (abs(a(1,2)) .gt. zero*(abs(d(1))+abs(d(2)))) then
        aux = a(2,2)-a(1,1)
        aux = (aux+sqrt(aux**2+4.d0*a(1,2)**2))/(2.d0*a(1,2))
!
        theta = atan2(aux,aux1)
!
        s(1,1) = cos(theta)
        s(2,2) = s(1,1)
        s(1,2) = sin(theta)
        s(2,1) = -s(1,2)
    else
        theta = 0.d0
        s(1,1) = 1.d0
        s(2,2) = 1.d0
        s(1,2) = 0.d0
        s(2,1) = 0.d0
    endif
end subroutine
