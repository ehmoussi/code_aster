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

subroutine di2epx(a, d)
!
    implicit none
!
!     DIAGONALISATION D'UNE MATRICE SYMETRIQUE 2x2
!
! IN  A : MATRICE SYM 2x2 SOUS FORME VECTORIEL 3x1 (A11,A22,A12)**t
!
! OUT D : MATRICE DIAG 2x2 SOUS FORME VECTORIEL 2x1 (D1,D2)**t
!
    real(kind=8) :: a(3), d(2), zero
    real(kind=8) :: aux, delta, rdelta, b, norme
!
    zero = 1.d-10
!
!     CALCUL DU (DELTA SUR QUATRE) DU POLYNOME CARACT DE LA MATRICE
!     POLY CARC = det(X*I-A) = X**2-X*(A(1)+A(2))+A(1)*A(2)-A(3)**2
!     DELTA / 4 = (A(1)-A(2))**2 / 4 + A(3)**2
!
    aux = (a(1)-a(2))*(a(1)-a(2))
    aux = 0.25d0 * aux
    delta = aux + a(3)*a(3)
!
    norme=abs(a(1))+abs(a(2))+abs(a(3))
!
!     CALCUL DE RACINE(DELTA/4)
    if (delta .ge. zero * norme**2) then
        rdelta = sqrt(delta)
    else
        rdelta=0.d0
    endif
!
!     CALCUL DES TERMES DE LA MATRICE DIAGONALISEE
    b = 0.5d0 * (a(1)+a(2))
    d(1) = b + rdelta
    d(2) = b - rdelta
!
end subroutine
