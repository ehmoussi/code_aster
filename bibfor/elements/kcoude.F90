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

subroutine kcoude(nbrddl, poids, b, c, k)
    implicit none
! ......................................................................
!
!    - FONCTION REALISEE:  CALCUL DE LA MATRICES K
!
!    - ARGUMENTS :
!         ENTREE :     NBRDDL  : NBRE DES DDL
!                      POIDS   : PRODUITS DES DIFFERENTS POIDS
!                                D'INTEGRATION ET DU JACOBIEN
!                      B       : MATRICE DE DEFORMATION
!                      C       : MATRICE DE COMPORTEMENT
!         SORTIE :     K       : MATRICE DE RIGIDITE
!
! ......................................................................
!
    integer :: i, j, nbrddl
!JMP      PARAMETER (NBRDDL=63)
    real(kind=8) :: b(4, nbrddl), c(4, 4), k(nbrddl, nbrddl), poids
    real(kind=8) :: c11b1i, c12b1i, c13b1i, c21b2i, c31b3i, c32b3i, c22b2i
    real(kind=8) :: c23b2i
    real(kind=8) :: c33b3i, c44b4i, cb1j, cb2j, cb3j
!
!
! CALCUL DE LA MATRICE DE RIGIDITE K
!
!
    do 10 i = 1, nbrddl
        c11b1i=c(1,1)* b(1,i)
        c12b1i=c(1,2)* b(1,i)
        c13b1i=c(1,3)* b(1,i)
        c21b2i=c(2,1)* b(2,i)
        c31b3i=c(3,1)* b(3,i)
        c32b3i=c(3,2)* b(3,i)
        c22b2i=c(2,2)* b(2,i)
        c23b2i=c(2,3)* b(2,i)
        c33b3i=c(3,3)* b(3,i)
        c44b4i=c(4,4)* b(4,i)
        cb1j=c11b1i+c21b2i+c31b3i
        cb2j=c22b2i+c12b1i+c32b3i
        cb3j=c13b1i+c23b2i+c33b3i
        do 20 j = 1, i
            k(i,j) = k(i,j) +( cb1j*b(1,j)+cb2j*b(2,j)+cb3j*b(3,j)+ c44b4i*b(4,j) ) *poids
            k(j,i) = k(i,j)
20      continue
10  end do
!
! FIN DU CALCUL DE LA MATRICE DE RIGIDITE
!
!
!
end subroutine
