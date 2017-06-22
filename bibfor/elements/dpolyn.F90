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

function dpolyn(n, coef, x)
!
    implicit none
!
!     EVALUE LA DERIVEE DU POLYNOME
!     Y = A1 + A2 * X + ... + A(N+1) * X**N
!     SOIT DY/DX = A2 + ... + N * A(N+1) * X**(N-1)
!
! IN  N : DEGRE DU POLYNOME
! IN  A : COEFFICIENT DU POLYNOME
! IN  X : VALEUR DE X OU EST EVALUE LE POLYNOME
!
! OUT DPOLYN : EVALUATION DE LA DERIVEE DU POLYNOME A X
!
    integer :: n, i
    real(kind=8) :: x, coef(n+1), dpolyn
!
!     INITIALISATION DE LA VARIABLE MAIS AUSSI VALEUR DE
!     LA DERIVEE POUR UN POLYNOME DE DEGRE 0
    dpolyn=0.d0
!
    if (n .gt. 0) then
        do 10, i = 1, n
        dpolyn = x*dpolyn + (n-i-1)*coef(n-i)
10      continue
    endif
!
end function
