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

subroutine dxhmft(dmf, jacob, hmft2)
    implicit  none
    real(kind=8) :: dmf(3, 3), jacob(*), hmft2(2, 6)
!     MATRICE PRODUIT HMF.T2(2,6)
!     -----------------------------------------------------------------
    integer :: j, k
    real(kind=8) :: vj11, vj12, vj21, vj22, hmf(2, 6), t2(3, 3)
!     ---------------------------------------------------------------
    vj11 = jacob(1)
    vj12 = jacob(2)
    vj21 = jacob(3)
    vj22 = jacob(4)
!
    hmf(1,1) = dmf(1,1)
    hmf(1,2) = dmf(3,3)
    hmf(1,3) = 2.d0 * dmf(1,3)
    hmf(1,4) = dmf(1,3)
    hmf(1,5) = dmf(2,3)
    hmf(1,6) = dmf(1,2) + dmf(3,3)
    hmf(2,1) = dmf(1,3)
    hmf(2,2) = dmf(2,3)
    hmf(2,3) = dmf(1,2) + dmf(3,3)
    hmf(2,4) = dmf(3,3)
    hmf(2,5) = dmf(2,2)
    hmf(2,6) = 2.d0 * dmf(2,3)
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
    do 100 k = 1, 2
        do 101 j = 1, 6
            hmft2(k,j) = 0.d0
101      continue
100  end do
    do 110 j = 1, 3
        do 110 k = 1, 3
            hmft2(1,j) = hmft2(1,j) + hmf(1,k) * t2(k,j)
            hmft2(1,j+3) = hmft2(1,j+3) + hmf(1,k+3) * t2(k,j)
            hmft2(2,j) = hmft2(2,j) + hmf(2,k) * t2(k,j)
            hmft2(2,j+3) = hmft2(2,j+3) + hmf(2,k+3) * t2(k,j)
110      continue
end subroutine
