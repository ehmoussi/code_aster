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

subroutine pmrvec(cumul, n, m, a, x,&
                  y)
    implicit none
    character(len=*) :: cumul
    integer :: n, m
    real(kind=8) :: a(n, m), x(m), y(n)
!       ----------------------------------------------------------------
!       PRODUIT D'UNE MATRICE RECTANGLE PLEINE PAR UN VECTEUR
!          Y(N) = 0.  + A(N,M)*X(M)
!       OU Y(N) = Y(N)+ A(N,M)*X(M)
!       ----------------------------------------------------------------
! IN    N, M  : I  :   DIMENSIONS DE LA MATRICE ET DES VECTEURS X ET Y
! IN    A(N,M): R  :   MATRICE REELLE
! IN    X(M)  : R  :   VECTEUR REEL
! IN    CUMUL : K* :   ON CUMULE OU NON DANS LE VECTEUR RESULTAT Y
!       CUMUL = 'ZERO' ON MET Y A ZERO AVANT DE COMMENCER
!       CUMUL = 'CUMU' ON ACCUMULE DANS Y
! OUT   Y(N)  : R  :   VECTEUR REEL
!       ----------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: i, j
!-----------------------------------------------------------------------
    if (cumul .eq. 'ZERO') then
        do 1 i = 1, n
            y(i) = 0.d0
 1      continue
    endif
!
    do 3 j = 1, m
        do 2 i = 1, n
            y(i) = y(i) + a(i,j) * x(j)
 2      continue
 3  continue
end subroutine
