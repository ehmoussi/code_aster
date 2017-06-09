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

subroutine vtmv(n, v, a, r)
    implicit none
    integer :: n
    real(kind=8) :: v(n), a(n, n), r
!     ------------------------------------------------------------------
! IN  N      :  DIMENSION DU VECTEUR
! IN  V      :  VECTEUR
! IN  A      :  MATRICE
! OUT R      :  REEL, RESULTAT DE VT*A*V
!     ------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: i, j
!-----------------------------------------------------------------------
    r = 0.d0
    do 10 i = 1, n
        do 10 j = 1, n
            r = r + v(i)*a(i,j)*v(j)
10      continue
!
end subroutine
