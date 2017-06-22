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

subroutine lcprsv(s, x, y)
    implicit none
!       PRODUIT SCALAIRE * VECTEUR  Y = S * X
!       IN  S      :  SCALAIRE
!       IN  X      :  VECTEUR
!       OUT Y      :  VECTEUR RESULTAT
!       ----------------------------------------------------------------
    integer :: n, nd, i
    real(kind=8) :: x(6), y(6), s
    common /tdim/   n , nd
    do 1 i = 1, n
        y(i) = s * x(i)
 1  continue
end subroutine
