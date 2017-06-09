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

subroutine lglpmv(cumul, n, a, x, y)
!
    implicit       none
    character(len=*) :: cumul
    integer :: n
    real(kind=8) :: a(6, 6), x(6), y(6)
! --- BUT : CALCUL DU PRODUIT MATRICE-VECTEUR --------------------------
! ======================================================================
! IN  : CUMUL  : K* :   ON CUMULE OU NON DANS LE VECTEUR RESULTAT Y ----
! --- : CUMUL = 'ZERO' ON MET Y A ZERO AVANT DE COMMENCER --------------
! --- : CUMUL = 'CUMU' ON ACCUMULE DANS Y ------------------------------
! --- : N      : DIMENSION REELLE DES MATRICES -------------------------
! --- : DIM    : DIMENSION EFFECTIVE DES MATRICES ----------------------
! --- : A      : MATRICE A ---------------------------------------------
! --- : X      : VECTEUR X ---------------------------------------------
! OUT : Y      : VECTEUR Y = A * X -------------------------------------
! ======================================================================
    integer :: i, j
! ======================================================================
    if (cumul .eq. 'ZERO') then
        do 1 i = 1, n
            y(i) = 0.0d0
 1      continue
    endif
! ======================================================================
    do 3 j = 1, n
        do 2 i = 1, n
            y(i) = y(i) + a(i,j) * x(j)
 2      continue
 3  continue
! ======================================================================
end subroutine
