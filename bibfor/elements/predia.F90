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

subroutine predia(a, b, diag, nno)
    implicit none
    integer :: i, ic, j, nno
!-----------------------------------------------------------------------
!
!    ESTIMATEUR ZZ (2-EME VERSION 92)
!
!      PRECONDITIONNEMENT PAR LA DIAGONALE DU SYSTEME LOCAL
!
    real(kind=8) :: a(9, 9), b(9, 4), diag(9)
    do 1 i = 1, nno
        diag(i) = 1.d0/sqrt(a(i,i))
 1  continue
    do 2 i = 1, nno
        do 3 j = 1, i
            a(i,j) = a(i,j) * diag(i) *diag(j)
 3      continue
 2  end do
    do 4 ic = 1, 4
        do 5 i = 1, nno
            b(i,ic) = b(i,ic) * diag(i)
 5      continue
 4  end do
    do 6 i = 1, nno
        do 7 j = i+1, nno
            a(i,j) = a(j,i)
 7      continue
 6  end do
end subroutine
