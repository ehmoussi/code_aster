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

subroutine mtcro3(m, n, a, nmax, x,&
                  y)
    implicit none
#include "asterfort/utmess.h"
!
    integer :: nmax, m, n
    real(kind=8) :: a(nmax, *), x(*), y(*)
!     ROUTINE UTILITAIRE POUR CALCULER Y = Y - A*X,
!     OPERATEUR APPELANT : MTCROG
! ----------------------------------------------------------------------
!     RESOLUTION D UN SYSTEME LINEAIRE AX = B PAR LA METHODE DE CROUT
!     POUR UNE MATRICE A QUELCONQUE DE DIMENSION N*N
!     SI B EST DE DIMENSION N*1, IL S AGIT D UN SIMPLE SYSTEME
!     LINEAIRE. SI B EST DE DIMENSION N*N, IL S AGIT DE L INVERSION
!     D UNE MATRICE
! ----------------------------------------------------------------------
! IN  : M      : NOMBRE DE LIGNES EFFECTIVES DE A
! IN  : N      : NOMBRE DE COLONNES EFFECTIVES DE A
! IN  : A      : MATRICE A DE DIMESION NMAX*N
! IN  : NMAX   : PREMIERE DIMENSION DU TABLEAU A
! IN  : X      : VECTEUR DE DIMESION SUPERIEURE OU EGALE A N
! IN/OUT: Y    : VECTEUR DE DIMESION SUPERIEURE OU EGALE A M
! ----------------------------------------------------------------------
    real(kind=8) :: zero
!-----------------------------------------------------------------------
    integer :: i, j
!-----------------------------------------------------------------------
    data zero    /0.d0/
! ----------------------------------------------------------------------
!
!
    if (( m.le.0 ) .and. ( n.le.0 )) then
        call utmess('A', 'ALGELINE2_13')
    endif
!
    do 20, j = 1, n
    if (x( j ) .ne. zero) then
        do 10, i = 1, m
        y( i ) = y( i ) - x( j )*a( i, j )
10      continue
    endif
    20 end do
!
!
end subroutine
