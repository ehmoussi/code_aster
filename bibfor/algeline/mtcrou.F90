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

subroutine mtcrou(a, b, nmax, n, nbscmb,&
                  l, d)
    implicit none
    real(kind=8) :: a(nmax, nmax), b(nmax, nbscmb), l(n, n), d(n)
!     ------------------------------------------------------------------
!     RESOLUTION PAR LA METHODE DE CROUT D'UN SYSTEME LINEAIRE
!     ------------------------------------------------------------------
! VAR A      : R8 : MATRICE CARREE PLEINE
! VAR B      : R8 : TABLEAU BI-INDICES DE REELS
!               EN ENTREE : LES SECONDS MEMBRES
!               EN SORTIE : LES SOLUTIONS
! IN  NMAX   : IS : DIM MAXI DE LA MATRICE
! IN  N      : IS : ORDRE DE LA MATRICE
! IN  NBSCMB : IS : NOMBRE DE SECOND MEMBRE
!     ------------------------------------------------------------------
    real(kind=8) :: zero, s
!
!-----------------------------------------------------------------------
    integer :: i, is, j, k, n, nbscmb, nmax
!
!-----------------------------------------------------------------------
    zero = 0.d0
    do 1 i = 1, n
        do 2 j = 1, i-1
            s = zero
            do 3 k = 1, j-1
                s = s + l(i,k)*d(k)*l(j,k)
 3          continue
            l(i,j) = (a(i,j)-s)/d(j)
 2      continue
        s = zero
        do 4 k = 1, i-1
            s = s + l(i,k)*l(i,k)*d(k)
 4      continue
        d(i) = a(i,i)-s
 1  end do
!
!   BOUCLE SUR LES SECONDS MEMBRES
!
    do 5 is = 1, nbscmb
!
!  DESCENTE
!
        do 6 i = 1, n
            s = zero
            do 7 k = 1, i-1
                s = s + l(i,k)*b(k,is)
 7          continue
            b(i,is) = b(i,is)-s
 6      end do
!
!  DIVISION PAR LA DIAGONALE
!
        do 10 i = 1, n
            b(i,is) = b(i,is)/d(i)
10      end do
!
!  REMONTEE
!
        do 8 i = n, 1, -1
            s = zero
            do 9 k = i+1, n
                s = s + l(k,i)*b(k,is)
 9          continue
            b(i,is) = b(i,is)-s
 8      end do
 5  end do
end subroutine
