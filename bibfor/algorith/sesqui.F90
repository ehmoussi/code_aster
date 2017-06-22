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

subroutine sesqui(mat, vect, ndim, normec)
    implicit   none
    integer :: ndim
    complex(kind=8) :: mat(*), vect(ndim), normec
!
!  BUT:  < NORME CARREE >
!
!   CETTE ROUTINE CALCULE LA NORME D'UNE VECTEUR COMPLEXE AU SENS DU
!   PRODUIT SCALAIRE COMPLEXE DEFINI PAR LA MATRICE COMPLEXE MAT
!
!-----------------------------------------------------------------------
!
! MAT      /I/: MATRICE COMPLEXE DEFINISSANT LE PRODUIT SCALAIRE
! VECT     /I/: VECTEUR COMPLEXE A NORMER
! NDIM     /I/: DIMENSION DU VECTEUR ET DE LA MATRICE
! NOR      /O/: NORME CARREE DU VECTEUR
!
!-----------------------------------------------------------------------
    integer :: i, j, idiag, jdiag
!-----------------------------------------------------------------------
!
    normec = dcmplx(0.d0,0.d0)
    do 10 i = 1, ndim
        idiag = i*(i-1)/2+1
        do 20 j = 1, ndim
            if (j .ge. i) then
                jdiag = j*(j-1)/2+1
                normec = normec + vect(j)*mat(jdiag+j-i)*dconjg(vect( i))
            else
                normec = normec + vect(j)*dconjg(mat(idiag+i-j))* dconjg(vect(i))
            endif
20      continue
10  continue
!
end subroutine
