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

subroutine subacv(cova, metr, jac, cnva, a)
!
    implicit none
!
    real(kind=8) :: cova(3, 3), metr(2, 2), jac
    real(kind=8) :: cnva(3, 2), a(2, 2)
!
!.......................................................................
!     CALCUL DE LA BASE CONTRAVARIANTE (EN DIMENSION 3)
!.......................................................................
! IN  COVA    COORDONNEES DES VECTEURS DE LA BASE COVARAINTE
! IN  METR    TENSEUR METRIQUE (2X2)
! IN  JAC     JACOBIEN DE LA METRIQUE
! OUT CNVA    COORDONNEES DES DEUX VECTEURS CONTRAVARIANTS
!     A       MATRICE PRODUIT SCALAIRE
!.......................................................................
!
    integer :: i
    real(kind=8) :: det
!
!
!    CALCUL DE LA METRIQUE CONTRAVARIANTE
    det = jac**2
    a(1,1) = metr(2,2) / det
    a(2,2) = metr(1,1) / det
    a(1,2) = - metr(2,1) / det
    a(2,1) = a(1,2)
!
!
!    CALCUL DES VECTEURS CONTRAVARIANTS
    do 10 i = 1, 3
        cnva(i,1) = a(1,1)*cova(i,1) + a(1,2)*cova(i,2)
        cnva(i,2) = a(2,1)*cova(i,1) + a(2,2)*cova(i,2)
10  end do
!
!
end subroutine
