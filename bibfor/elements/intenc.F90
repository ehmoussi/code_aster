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

subroutine intenc(nbna, jac, vectx, vecty, mat11,&
                  mat22, mat12, nx, ny, inte)
    implicit none
    integer :: nbna
    real(kind=8) :: jac(3), vectx(3), vecty(3), mat11(3), mat22(3), mat12(3)
    real(kind=8) :: nx(3), ny(3), inte
!
!     BUT:
!         CALCUL DES TERMES PAR NOEUD POUR UNE INTEGRATION
!         DE NEWTON-COTES À 2 OU 3 POINTS DU TYPE :
!              (
!              |     (VECT-MAT.N)**2 dBORD
!              )BORD
!
!
!     ARGUMENTS:
!     ----------
!
!      ENTREE :
!-------------
! IN   NBNA   : NOMBRE DE POINTS D'INTEGRATION
! IN   JAC    : VECTEUR DES JACOBIENS DE LA TRANSFORMATION AUX NOEUDS
! IN   VECTX  : COMPOSANTES EN X DU VECTEUR AUX NOEUDS
! IN   VECTY  : COMPOSANTES EN Y DU VECTEUR AUX NOEUDS
! IN   MAT11  : COMPOSANTES 11 DE LA MATRICE AUX NOEUDS
! IN   MAT22  : COMPOSANTES 22 DE LA MATRICE AUX NOEUDS
! IN   MAT12  : COMPOSANTES 12 DE LA MATRICE AUX NOEUDS
! IN   NX     : VECTEUR DES ABSCISSES DES NORMALES AUX NOEUDS
! IN   NY     : VECTEUR DES ORDONNEES DES NORMALES AUX NOEUDS
!
!      SORTIE :
!-------------
! OUT  INTE   : VALEUR DE L'INTEGRALE
!
! ----------------------------------------------------------------------
    real(kind=8) :: inte1, inte2, inte3, poids(3)
! ----------------------------------------------------------------------
!
!        ON REALISE UNE INTEGRATION DE NEWTON-COTES AVEC 2 OU 3 POINTS
!        D'INTEGRATION SELON LE NOMBRE DE POINTS DE L'ARETE CONSIDEREE
!        SOIT NBNA = 2 OU 3
!
    inte1=jac(1)*&
     &      ((vectx(1)-mat11(1)*nx(1)-mat12(1)*ny(1))**2&
     &      +(vecty(1)-mat12(1)*nx(1)-mat22(1)*ny(1))**2)
!
    inte2=jac(2)*&
     &      ((vectx(2)-mat11(2)*nx(2)-mat12(2)*ny(2))**2&
     &      +(vecty(2)-mat12(2)*nx(2)-mat22(2)*ny(2))**2)
!
    poids(1)=1.d0
    poids(2)=1.d0
!
    inte=inte1*poids(1)+inte2*poids(2)
!
    if (nbna .eq. 3) then
!
        inte3=jac(3)* ((vectx(3)-mat11(3)*nx(3)-mat12(3)*ny(3))**2&
        +(vecty(3)-mat12(3)*nx(3)-mat22(3)*ny(3))**2)
!
        poids(1)=1.d0/3.d0
        poids(2)=1.d0/3.d0
        poids(3)=4.d0/3.d0
!
        inte=inte1*poids(1)+inte2*poids(2)+inte3*poids(3)
!
    endif
!
end subroutine
