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

subroutine extrma(amatst, nlig, ncol, nmat, amat)
!
! FONCTION: EXTRAIT LA MATRICE AMAT(I,J) A NLIG LIGNES ET NCOL COLONNES
!           DU TABLEAU AMATST(I,J,NMAT)
!
!     IN  : AMATST    : TABLEAU DIMENSIONNE 9,6,6
!           NLIG      : ENTIER
!           NCOL      : ENTIER
!           NMAT      : ENTIER
!
!     OUT : AMAT      : MATRICE DIMENSIONNEE NLIG,NCOL
! ------------------------------------------------------------------
    implicit none
    integer :: ncol, nlig
    real(kind=8) :: amatst(9, 6, 6), amat(nlig, ncol)
    integer :: i, j, nmat
!-----------------------------------------------------------------------
!
    do 2 j = 1, ncol
        do 1 i = 1, nlig
            amat(i,j) = amatst(i,j,nmat)
 1      end do
 2  end do
end subroutine
