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

subroutine cumuma(i, j, pmat, coef, gmat)
!
! FONCTION: CUMULE LES ELEMENTS DE LA MATRICE PMAT, MULTIPLIES PAR COEF,
!           A CEUX DE LA MATRICE GMAT, SELON LA FORMULE:
! GMAT((I-1)*6+I1,(J-1)*6+J1) = GMAT((I-1)*6+I1,(J-1)*6+J1) +
!                               PMAT(I1,J1)
!
!     IN  : I,J       : POINTEURS SUR LA MATRICE GMAT
!           PMAT      : MATRICE D'ORDRE 6
!           COEF      : SCALAIRE
!
!     OUT : GMAT      : MATRICE D'ORDRE 18
! ------------------------------------------------------------------
    implicit none
    real(kind=8) :: pmat(6, 6), gmat(18, 18)
!
!-----------------------------------------------------------------------
    integer :: i, i1, i2, ii, j, j1, j2
    integer :: jj
    real(kind=8) :: coef
!-----------------------------------------------------------------------
    i1 = (i-1) * 6
    j1 = (j-1) * 6
    do 12 j2 = 1, 6
        jj = j1 + j2
        do 11 i2 = 1, 6
            ii = i1 + i2
            gmat(ii,jj) = gmat(ii,jj) + coef*pmat(i2,j2)
11      end do
12  end do
end subroutine
