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

subroutine lcdevi(a, d)
    implicit none
!       DEVIATEUR D UN TENSEUR (3X3) SOUS FORME VECTEUR  (6X1)
!       IN  A      :  TENSEUR
!       OUT D      :  DEVIATEUR DE A = A - 1/3 TR(A) I
!       ----------------------------------------------------------------
    integer :: n, nd
    real(kind=8) :: a(6), d(6), ta
    common /tdim/   n , nd
!
!
!-----------------------------------------------------------------------
    integer :: i
!-----------------------------------------------------------------------
    ta = 0.d0
    do 1 i = 1, nd
        ta = ta + a(i)
 1  continue
    ta = ta / 3.d0
    do 2 i = 1, nd
        d(i) = a(i) - ta
 2  continue
    do 3 i = nd + 1, n
        d(i) = a(i)
 3  continue
end subroutine
