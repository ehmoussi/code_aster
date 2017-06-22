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

subroutine dstbfb(jacob, bfb)
    implicit  none
    real(kind=8) :: jacob(*), bfb(3, 9)
!     MATRICE BFB(3,9) POUR L'ELEMENT DST
!     ------------------------------------------------------------------
    integer :: k, j
    real(kind=8) :: vj11, vj12, vj21, vj22
!     ------------------------------------------------------------------
    vj11 = jacob(1)
    vj12 = jacob(2)
    vj21 = jacob(3)
    vj22 = jacob(4)
!
    do 100 k = 1, 3
        do 101 j = 1, 9
            bfb(k,j) = 0.d0
101      continue
100  end do
    bfb(1,2) = - vj11 - vj12
    bfb(1,5) = vj11
    bfb(1,8) = vj12
    bfb(2,3) = - vj21 - vj22
    bfb(2,6) = vj21
    bfb(2,9) = vj22
    bfb(3,2) = - vj21 - vj22
    bfb(3,3) = - vj11 - vj12
    bfb(3,5) = vj21
    bfb(3,6) = vj11
    bfb(3,8) = vj22
    bfb(3,9) = vj12
!
end subroutine
