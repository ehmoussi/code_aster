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

subroutine dsxhlt(df, jacob, hlt2)
    implicit  none
    real(kind=8) :: df(3, 3), jacob(*), hlt2(4, 6)
!     MATRICE PRODUIT HL.T2(4,6)
!     -----------------------------------------------------------------
    integer :: i, j, k
    real(kind=8) :: vj11, vj12, vj21, vj22, hl(4, 6), t2(3, 3)
!     ---------------------------------------------------------------
    vj11 = jacob(1)
    vj12 = jacob(2)
    vj21 = jacob(3)
    vj22 = jacob(4)
!
    hl(1,1) = df(1,1)
    hl(1,2) = - df(3,3)
    hl(1,3) = 0.d0
    hl(1,4) = df(1,3)
    hl(1,5) = - df(2,3)
    hl(1,6) = df(1,2) - df(3,3)
    hl(2,1) = df(1,3)
    hl(2,2) = - df(2,3)
    hl(2,3) = df(3,3) - df(1,2)
    hl(2,4) = df(3,3)
    hl(2,5) = - df(2,2)
    hl(2,6) = 0.d0
    hl(3,1) = df(1,2)
    hl(3,2) = 0.d0
    hl(3,3) = df(2,3)
    hl(3,4) = df(2,3)
    hl(3,5) = 0.d0
    hl(3,6) = df(2,2)
    hl(4,1) = 0.d0
    hl(4,2) = df(1,3)
    hl(4,3) = df(1,1)
    hl(4,4) = 0.d0
    hl(4,5) = df(1,2)
    hl(4,6) = df(1,3)
!
    t2(1,1) = vj11 * vj11
    t2(1,2) = vj12 * vj12
    t2(1,3) = 2.d0 * vj11 * vj12
    t2(2,1) = vj21 * vj21
    t2(2,2) = vj22 * vj22
    t2(2,3) = 2.d0 * vj21 * vj22
    t2(3,1) = vj11 * vj21
    t2(3,2) = vj12 * vj22
    t2(3,3) = vj11 * vj22 + vj12 * vj21
!
    do 100 k = 1, 4
        do 101 j = 1, 6
            hlt2(k,j) = 0.d0
101      continue
100  end do
    do 110 i = 1, 4
        do 110 j = 1, 3
            do 110 k = 1, 3
                hlt2(i,j) = hlt2(i,j) + hl(i,k) * t2(k,j)
                hlt2(i,j+3) = hlt2(i,j+3) + hl(i,k+3) * t2(k,j)
110          continue
end subroutine
