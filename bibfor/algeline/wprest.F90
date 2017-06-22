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

subroutine wprest(a, x, n, m, y)
    implicit none
!
    complex(kind=8) :: y(*)
    real(kind=8) :: a(n, *), x(*)
    integer :: n, m
!
!     RESTITUTION DES VECTEUR PROPRES DU PB QUADRATIQUE
!     IE :         Y := A*X
!     --------------------------------------------------------------
! IN  A : R : MATRICE DES VECTEUR DE LANCZOS
! IN  X : C : MATRICE DES VECTEUR PROPRES DU PB REDUIT
! IN  N : I : TAILLE DES VECTEURS PROPRES DU PB QUADRATIQUE
! IN  M : I : TAILLE DES VECTEURS PROPRES DU PB REDUIT
! IN  Y : C : MATRICE DES VECTEUR PROPRES DU PB QUADRATIQUE
!     --------------------------------------------------------------
    complex(kind=8) :: cval, czero
    integer :: i, j
!     --------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: k
!-----------------------------------------------------------------------
    czero = dcmplx(0.0d0,0.0d0)
    do 100, i = 1, n, 1
    cval = czero
    k = 1
    do 110, j = 1, m, 1
    cval = cval + a(i,j)*dcmplx(x(k),x(k+1))
    k = k+2
110  continue
    y(i) = cval
    100 end do
!
end subroutine
