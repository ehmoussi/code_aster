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

subroutine matmul(a, b, n1, n2, n3,&
                  ab)
!
    implicit none
!
!     REALISE LA MULTIPLICATION DE DEUX MATRICES
!
! IN  A : MATRICE
! IN  B : MATRICE
! IN N1 : DIMENSION DE MATRICE
! IN N2 : DIMENSION DE MATRICE
! IN N3 : DIMENSION DE MATRICE
!
! OUT AB : PRODUIT DES MATRICES A x B
!
!
#include "asterfort/r8inir.h"
    integer :: n1, n2, n3, i, j, k
!      REAL*8 A(N1,*),B(N2,*),AB(N1,*)
    real(kind=8) :: a(n1, n2), b(n2, n3), ab(n1, n3)
!
    call r8inir(n1*n3, 0.d0, ab, 1)
!
    do 30, k = 1,n3
    do 20, j = 1,n2
    do 10, i = 1,n1
    ab(i,k) = ab(i,k) + a(i,j)*b(j,k)
10  continue
20  continue
    30 end do
!
end subroutine
