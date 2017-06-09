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

subroutine intega(npgf, jac, poidsf, vectx, vecty,&
                  vectz, mat11, mat22, mat33, mat12,&
                  mat13, mat23, nx, ny, nz,&
                  inte)
    implicit none
    integer :: npgf
    real(kind=8) :: jac(9), poidsf(9)
    real(kind=8) :: vectx(9), vecty(9), vectz(9)
    real(kind=8) :: mat11(9), mat22(9), mat33(9), mat12(9), mat13(9), mat23(9)
    real(kind=8) :: nx(9), ny(9), nz(9)
    real(kind=8) :: inte
!
!     BUT:
!         CALCUL DES TERMES PAR POINT DE GAUSS POUR UNE INTEGRATION
!         DE GAUSS DU TYPE :
!              (
!              |     (VECT-MAT.N)**2 DFACE
!              )FACE
!
!
!     ARGUMENTS:
!     ----------
!
!      ENTREE :
!-------------
! IN   NPGF   : NOMBRE DE POINTS D'INTEGRATION
! IN   JAC    : VECTEUR DES JACOBIENS DE LA TRANSFORMATION AUX NOEUDS
! IN   POIDSF : VECTEUR DES POIDS AUX NOEUDS POUR LA FACE
! IN   VECTX  : COMPOSANTES EN X DU VECTEUR AUX NOEUDS
! IN   VECTY  : COMPOSANTES EN Y DU VECTEUR AUX NOEUDS
! IN   VECTZ  : COMPOSANTES EN Z DU VECTEUR AUX NOEUDS
! IN   MATIJ  : COMPOSANTES IJ DE LA MATRICE AUX NOEUDS
! IN   NX     : COMPOSANTES EN X DES NORMALES AUX NOEUDS
! IN   NY     : COMPOSANTES EN Y DES NORMALES AUX NOEUDS
! IN   NZ     : COMPOSANTES EN Z DES NORMALES AUX NOEUDS
!
!      SORTIE :
!-------------
! OUT  INTE  : TERME INTEGRE POUR UNE FACE
!
! ......................................................................
    integer :: ipgf
! ----------------------------------------------------------------------
!
    inte=0.0d0
!
    do 10 , ipgf = 1 , npgf
!
    inte=inte+((vectx(ipgf)-mat11(ipgf)*nx(ipgf) -mat12(ipgf)*ny(&
        ipgf)-mat13(ipgf)*nz(ipgf))**2 +(vecty(ipgf)-mat12(ipgf)*nx(&
        ipgf) -mat22(ipgf)*ny(ipgf)-mat23(ipgf)*nz(ipgf))**2 +(vectz(&
        ipgf)-mat13(ipgf)*nx(ipgf) -mat23(ipgf)*ny(ipgf)-mat33(ipgf)*&
        nz(ipgf))**2) *poidsf(ipgf)*jac(ipgf)
!
    10 end do
!
end subroutine
