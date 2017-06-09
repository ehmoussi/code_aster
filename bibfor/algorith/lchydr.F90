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

subroutine lchydr(a, h)
    implicit none
!       SPHERIQUE  D UN TENSEUR (3X3) SOUS FORME VECTEUR  (6X1)
!       IN  A      :  TENSEUR
!       OUT H      :  PARTIE SPHERIQUE DE A    H = 1/3 TR(A)
!       ----------------------------------------------------------------
    integer :: n, nd
    real(kind=8) :: a(6), ta, d13, h
    common /tdim/   n , nd
!-----------------------------------------------------------------------
    integer :: i
!-----------------------------------------------------------------------
    data   d13      /.33333333333333d0 /
!       ----------------------------------------------------------------
    ta = 0.d0
    do 1 i = 1, nd
        ta = ta + a(i)
 1  continue
    h = ta * d13
end subroutine
