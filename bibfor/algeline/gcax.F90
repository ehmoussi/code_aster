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

subroutine gcax(m, in, ip, ac, x,&
                y)
! aslint: disable=W1304, C1513
    implicit none
    integer(kind=4) :: ip(*)
    integer :: m, in(m)
    real(kind=8) :: ac(*), x(m), y(m)
    real(kind=8) :: dtemp
!     ------------------------------------------------------------------
!     MULTIPLICATION D'UNE MATRICE SYMETRIQUE COMPACTE PAR
!                UN VECTEUR :  Y = AC*X
!     ------------------------------------------------------------------
! IN . M             -->   NOMBRE DE COLONNES DE LA MATRICE
! IN . IN(I=1,M)     -->   POINTEUR DE FIN DE COLONNE DE LA MATRICE
! IN . IP(J)         -->   TABLEAU DES NUMEROS DE LIGNE
! IN . AC(J)         -->   TABLEAU DES COEFFICIENTS DE LA MATRICE
! IN . X(I=1,M)      -->   VECTEUR D'ENTREE
! OUT. Y(I=1,M)     <--    VECTEUR DE SORTIE
!     _____________ ____ ______________________________________________
!-----------------------------------------------------------------------
    integer :: i, j, kdeb, kfin, ki, klong
!-----------------------------------------------------------------------
    y(1) = ac(1)*x(1)
    do 10 i = 2, m
        kdeb = in(i-1)+1
        kfin = in(i)-1
        klong = in(i)
        dtemp = 0.0d0
        do 30 j = kdeb, klong
            dtemp = dtemp + x(ip(j))*ac(j)
30      continue
        y(i) = dtemp
        dtemp = x(i)
!DIR$ IVDEP
!DIR$ NOPREFETCH Y
        do 20 ki = kdeb, kfin
            y(ip(ki)) = y(ip(ki)) + ac(ki)*dtemp
20      continue
10  end do
!
end subroutine
