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

subroutine amppr(amat, nb1, nb2, bmat, n1,&
                 n2, i, j)
    implicit none
!
!***********************************************************************
!    P. RICHARD     DATE 12/03/91
!-----------------------------------------------------------------------
!  BUT:  AJOUTER UNE MATRICE PLEINE REELLE A UNE MATRICEPLEINE REELLE
!            A UNE MATRICE PLEINE REELLE
!-----------------------------------------------------------------------
!
! AMAT     /M/: MATRICE RECEPTRICE
! NB1      /I/: NB DE LIGNES DE LA MATRICE RECEPTRICE
! NB2      /I/: NB DE COLONNES DE LA MATRICE RECEPTRICE
! BMAT     /M/: MATRICE PLEINE A AJOUTER
! N1       /I/: NB DE LIGNE DE LA MATRICE A AJOUTER
! N2       /I/: NB DE COLONNE DE LA MATRICE A AJOUTER
! I        /I/: INDICE DU PREMIER TERME DANS RECEPTRICE
! J        /I/: INDICE DE COLONNE TERME  DANS RECEPTRICE
!
!-----------------------------------------------------------------------
!
    real(kind=8) :: amat(nb1, nb2), bmat(n1, n2)
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: i, ideb, ifin, ii, iideb, iifin, j
    integer :: jdeb, jfin, jj, jjdeb, jjfin, n1, n2
    integer :: nb1, nb2
!-----------------------------------------------------------------------
    jdeb=j
    jfin=min(j+n2-1,nb2)
    if (jfin .lt. jdeb) goto 9999
    jjdeb=jdeb-j+1
    jjfin=jfin-j+1
!
    ideb=i
    ifin=min(i+n1-1,nb1)
    if (ifin .lt. ideb) goto 9999
    iideb=ideb-i+1
    iifin=ifin-i+1
!
    do 10 ii = iideb, iifin
        do 20 jj = jjdeb, jjfin
            amat(i+ii-1,j+jj-1)=amat(i+ii-1,j+jj-1)+bmat(ii,jj)
20      continue
10  end do
!
9999  continue
end subroutine
