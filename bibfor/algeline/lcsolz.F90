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

subroutine lcsolz(a, b, ndim, n, nbscmb,&
                  iret)
    implicit none
!     RESOLUTION PAR LA METHODE DE GAUSS D'UN SYSTEME LINEAIRE
!     A COEFFICIENTS COMPLEXES
!     ------------------------------------------------------------------
!       VAR A      : C16: MATRICE CARREE PLEINE
!       VAR B      : C16: TABLEAU BI-INDICE DE COMPLEXES
!                       EN ENTREE : LES SECONDS MEMBRES
!                       EN SORTIE : LES SOLUTIONS
!       IN  N      : IS : ORDRE DE LA MATRICE
!       IN  NDIM   : IS : DIMENSION DECLAREE DE LA MATRICE
!       IN  NBSCMB : IS : NOMBRE DE SECONDS MEMBRES
!      OUT  IRET   : IS : 0 OK
!                         1 PIVOT NUL
!     ------------------------------------------------------------------
#include "asterc/r8miem.h"
#include "asterfort/dcabs2.h"
    integer :: ipivot
    real(kind=8) :: apivot, zero, rmin
    complex(kind=8) :: ak, bk
    complex(kind=8) :: a(ndim, ndim), b(ndim, nbscmb)
!
!-----------------------------------------------------------------------
    integer :: i, ic, il, iret, iscmb, j, k
    integer :: n, nbscmb, ndim
!-----------------------------------------------------------------------
    iret = 0
    zero = 0.d0
    rmin = 100.d0*r8miem()
    do 1000 i = 1, n-1
!
!        DETERMINATION DU MEILLEUR PIVOT SUR LA COLONNE
        apivot = dcabs2(a(i,i))
        ipivot = i
        do 100 k = i+1, n
            if (apivot - dcabs2(a(k,i)) .lt. zero) then
                apivot = dcabs2(a(k,i))
                ipivot = k
            endif
100      continue
        if (apivot .lt. rmin) then
            iret = 1
            goto 9999
        endif
!
!        PERMUTATION DES LIGNES DE LA MATRICE
        do 200 j = 1, n
            ak = a(i,j)
            a(i,j) = a(ipivot,j)
            a(ipivot,j) = ak
200      continue
!
!        PERMUTATION DES LIGNES DES SECONDS MEMBRES
        do 300 iscmb = 1, nbscmb
            bk = b(i,iscmb)
            b(i,iscmb) = b(ipivot,iscmb)
            b(ipivot,iscmb) = bk
300      continue
!
!        CALCUL DES NOUVEAUX TERMES DE LA MATRICE ET DES SECONDS MEMBRES
        do 600 il = i+1, n
            do 400 iscmb = 1, nbscmb
                b(il,iscmb) = b(il,iscmb) - a(il,i)*b(i,iscmb)/a(i,i)
400          continue
            do 500 ic = i+1, n
                a(il,ic) = a(il,ic) - a(il,i)*a(i,ic)/a(i,i)
500          continue
600      continue
!
1000  end do
!
!     RESOLUTION
    do 1100 iscmb = 1, nbscmb
        b(n,iscmb) = b(n,iscmb)/a(n,n)
        do 1200 i = n-1, 1, -1
            do 1300 j = i+1, n
                b(i,iscmb) = b(i,iscmb)-a(i,j)*b(j,iscmb)
1300          continue
            b(i,iscmb) = b(i,iscmb)/a(i,i)
1200      continue
1100  end do
!
9999  continue
end subroutine
