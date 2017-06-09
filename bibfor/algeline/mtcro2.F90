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

subroutine mtcro2(n, a, nmax, x)
    implicit none
#include "asterfort/utmess.h"
!
    integer :: nmax, n
    real(kind=8) :: a(nmax, *), x(*)
!     ROUTINE UTILITAIRE POUR RESOUDRE UNE DES EQUATIONS DU SYSTEME
!     A*X = B
!     OPERATEUR APPELANT : MTCROG
! ----------------------------------------------------------------------
!     RESOLUTION D UN SYSTEME LINEAIRE AX = B PAR LA METHODE DE CROUT
!     POUR UNE MATRICE A QUELCONQUE DE DIMENSION N*N
!     SI B EST DE DIMENSION N*1, IL S AGIT D UN SIMPLE SYSTEME
!     LINEAIRE. SI B EST DE DIMENSION N*N, IL S AGIT DE L INVERSION
!     D UNE MATRICE
! ----------------------------------------------------------------------
! IN  : M      : NOMBRE DE LIGNES EFFECTIVES DE A
! IN  : A      : MATRICE A DE DIMESION NMAX*N. A EST UNE MATRICE
!                TRIANGULAIRE SUPERIEURE, UNITAIRE.
! IN  : NMAX   : PREMIERE DIMENSION DU TABLEAU A
! IN/OUT: X    : VECTEUR DE DIMESION SUPERIEURE OU EGALE A N
!                X CONTIENT EN ENTREE LES N ELEMENTS DU VECTEUR B, ET
!                EN SORTIE, LA SOLUTION X
! ----------------------------------------------------------------------
    real(kind=8) :: zero
!-----------------------------------------------------------------------
    integer :: i, j
!-----------------------------------------------------------------------
    data zero    /0.d0/
! ----------------------------------------------------------------------
!
!
    if (n .lt. 0 .or. nmax .lt. 1 .or. nmax .lt. n) then
        call utmess('A', 'ALGELINE2_12')
    endif
!
    do 20, j = n, 1, -1
    if (x( j ) .ne. zero) then
        do 10, i = j - 1, 1, -1
        x( i ) = x( i ) - x( j )*a( i, j )
10      continue
    endif
    20 end do
!
end subroutine
