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

subroutine prmave(ipr, amat, na, na1, na2,&
                  bvec, nb1, cvec, nc1, ier)
!
!
    implicit none
    integer :: na
    integer :: na1, na2, nb1, nc1, ipr, ier
    real(kind=8) :: amat(na, *), bvec(*), cvec(*)
!
! ----------------------------------------------------------------------
!
! ROUTINE UTILITAIRE
!
! PRODUIT  MATRICE VECTEUR : C = A * B
!
!
! ----------------------------------------------------------------------
!
!
! IN  IPR      : =  0 => C = A * B
!                <> 0 => C = C + A * B
! IN  AMAT     : MATRICE A
! IN  NA       : NOMBRE DE LIGNES DE AMAT
! IN  NA1      : NOMBRE DE LIGNES UTILISEES DANS AMAT
!                POUR LA MULTIPLICATION
! IN  NA2      : NOMBRE DE COLONNES UTILISEES DANS AMAT
!                POUR LA MULTIPLICATION
! IN  BVEC     : VECTEUR B
! IN  NB1      : NOMBRE DE LIGNES UTILISEES DANS B
!                POUR LA MULTIPLICATION
! OUT CVEC     : VECTEUR RESULTAT C
! IN  NC1      : NOMBRE DE LIGNES DE C
! IN  IER      : CODE RETOUR : = 0 => TOUT S'EST BIEN PASSE
!                              > 0 => CA S'EST MAL PASSE
!
!
! ----------------------------------------------------------------------
!
    integer :: i, j
!
! ----------------------------------------------------------------------
!
    ier=0
!
    if (na2 .ne. nb1) then
        ier = ier + 1
    endif
!
    if (nc1 .ne. na1) then
        ier = ier + 1
    endif
!
    if (ier .eq. 0) then
!
        if (ipr .eq. 0) then
!
            do 10 i = 1, na1
                cvec(i)=0.0d0
10          continue
!
        endif
!
        do 20 i = 1, na1
            do 30 j = 1, na2
                cvec(i)=cvec(i)+amat(i,j)*bvec(j)
30          continue
20      continue
!
    endif
!
end subroutine
