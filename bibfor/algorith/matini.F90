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

subroutine matini(nlig, ncol, s, mat)
    implicit none
!
    integer :: nlig, ncol
    real(kind=8) :: s, mat(nlig, ncol)
!            INITIALISATION D'UNE MATRICE PAR UN SCALAIRE (RÉEL)
!
!       IN   NLIG    :  NOMBRE DE LIGNES DE LA MATRICE
!       IN   NCOL    :  NOMBRE DE COLONNES DE LA MATRICE
!       IN   S       :  SCALAIRE
!       OUT  MAT     :  MATRICE
!-----------------------------------------------------------------------
!
! NOTE SUR L'UTILISATION DE LA ROUTINE :
! ====================================
! CETTE ROUTINE PERMET D'INITIALISER UNE MATRICE MAIS NE PERMET PAS
! D'INITIALISER UN SOUS-BLOC D'UNE MATRICE. CECI A CAUSE DE LA
! DECLARATION DE LA MATRICE DANS LA PRESENTE ROUTINE.
! SI L'ON SOUHAITE QUAND MEME ECONOMISER DE LA MEMOIRE EN N'INITIALISANT
! QUE LE NECESSAIRE ALORS IL FAUT DONNER AU MINIMUM LE VRAI NOMBRE DE
! LIGNE DE LA MATRICE. A NOTER QUE CELA N'ECONOMISE PAS GRAND CHOSE.
!
!-----------------------------------------------------------------------
!
    integer :: i, j
!
    do 10 j = 1, ncol
        do 20 i = 1, nlig
            mat(i,j) = s
20      continue
10  end do
end subroutine
