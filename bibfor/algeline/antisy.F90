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

subroutine antisy(axial, coef, amat)
!
! FONCTION: FORME LA MATRICE ANTISYMETRIQUE 'AMAT' DE VECTEUR AXIAL
!           'AXIAL' ET MULTIPLIE LES ELEMENTS DE LA MATRICE PAR COEF.
!
!     IN  : AXIAL     : VECTEUR D'ORDRE 3
!           COEF      : SCALAIRE
!
!     OUT : AMAT      : MATRICE D'ORDRE 3
! ------------------------------------------------------------------
    implicit none
    real(kind=8) :: axial(3), amat(3, 3)
!
!-----------------------------------------------------------------------
    integer :: i, j
    real(kind=8) :: coef, zero
!-----------------------------------------------------------------------
    zero = 0.d0
    do 2 j = 1, 3
        do 1 i = 1, 3
            amat(i,j) = zero
 1      end do
 2  end do
    amat(1,2) = -coef * axial(3)
    amat(1,3) = coef * axial(2)
    amat(2,1) = coef * axial(3)
    amat(2,3) = -coef * axial(1)
    amat(3,1) = -coef * axial(2)
    amat(3,2) = coef * axial(1)
end subroutine
