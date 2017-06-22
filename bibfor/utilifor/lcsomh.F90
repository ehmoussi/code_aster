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

subroutine lcsomh(a, h, m)
    implicit none
!       SOMME D'UN TENSEUR (3X3) SOUS FORME VECTEUR  (6X1)
!       ET D'UNE PARTIE MOYENNE (SCALAIRE)
!       IN  A      :  TENSEUR
!           H      :  PARTIE HYDROSTATIQUE
!       OUT M      :  DEVIATEUR DE A = A + H I
!       ----------------------------------------------------------------
    integer :: n, nd, i
    real(kind=8) :: a(6), m(6), h
    common /tdim/   n , nd
!      ----------------------------------------------------------------
    do 2 i = 1, nd
        m(i) = a(i) + h
 2  continue
    do 3 i = nd + 1, n
        m(i) = a(i)
 3  continue
end subroutine
