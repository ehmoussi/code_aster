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

subroutine dsqbfb(qsi, eta, jacob, bfb)
    implicit none
    real(kind=8) :: qsi, eta, jacob(*), bfb(3, 12)
!     MATRICE BFB(3,12) AU POINT QSI ETA POUR L'ELEMENT DSQ
!     -----------------------------------------------------
    integer :: k, j
    real(kind=8) :: vj11, vj12, vj21, vj22, peta, meta, pqsi, mqsi
!     ------------------------------------------------------------------
    vj11 = jacob(1)
    vj12 = jacob(2)
    vj21 = jacob(3)
    vj22 = jacob(4)
!
    peta = (1.d0 + eta) / 4.d0
    meta = (1.d0 - eta) / 4.d0
    pqsi = (1.d0 + qsi) / 4.d0
    mqsi = (1.d0 - qsi) / 4.d0
!
    do 100 k = 1, 3
        do 101 j = 1, 12
            bfb(k,j) = 0.d0
101      continue
100  end do
!
    bfb(1, 2) = - meta * vj11 - mqsi * vj12
    bfb(1, 5) = meta * vj11 - pqsi * vj12
    bfb(1, 8) = peta * vj11 + pqsi * vj12
    bfb(1,11) = - peta * vj11 + mqsi * vj12
    bfb(2, 3) = - meta * vj21 - mqsi * vj22
    bfb(2, 6) = meta * vj21 - pqsi * vj22
    bfb(2, 9) = peta * vj21 + pqsi * vj22
    bfb(2,12) = - peta * vj21 + mqsi * vj22
    bfb(3, 2) = bfb(2, 3)
    bfb(3, 3) = bfb(1, 2)
    bfb(3, 5) = bfb(2, 6)
    bfb(3, 6) = bfb(1, 5)
    bfb(3, 8) = bfb(2, 9)
    bfb(3, 9) = bfb(1, 8)
    bfb(3,11) = bfb(2,12)
    bfb(3,12) = bfb(1,11)
!
end subroutine
