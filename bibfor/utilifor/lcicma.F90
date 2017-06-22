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

subroutine lcicma(a, la, ca, lc, cc,&
                  xa, ya, b, lb, cb,&
                  xb, yb)
    implicit none
!       INCLUSION D UNE SOUS MATRICE C(LC,CC) SE TROUVANT
!       AU POINT (XA,YA) DE LA MATRICE  A(LA,CA)
!       DANS UNE MATRICE B(LB,CB) AU POINT (XB,YB)
!
!       IN  LA  CA  :  NB LIGNES ET COLONNES  DE A
!       IN  LC  CC  :  NB LIGNES ET COLONNES  DE C
!       IN  XA  YA  :  LIGNE , COLONNE DU POINT INCLUSION DE SA DANS A
!       IN  LB  CB  :  NB LIGNES ET COLONNES  DE B
!       IN  XB  YB  :  LIGNE , COLONNE DU POINT D INCLUSION DE SA DANS B
!       IN  A       :  MATRICE EMETTEUR
!       OUT B       :  MATRICE RECEPTEUR
!       ----------------------------------------------------------------
    integer :: la, ca, lc, cc, xa, ya, lb, cb, xb, yb, i, j
    real(kind=8) :: a(la, ca), b(lb, cb)
!
    do 1 i = 1, lc
        do 1 j = 1, cc
            b ( xb+i-1 , yb+j-1 ) = a ( xa+i-1 , ya+j-1 )
 1      continue
end subroutine
