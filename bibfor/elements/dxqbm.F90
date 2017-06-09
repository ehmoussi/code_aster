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

subroutine dxqbm(qsi, eta, jacob, bm)
    implicit  none
    real(kind=8) :: qsi, eta, jacob(*), bm(3, 8)
!     MATRICE BM(3,8) MEMBRANE AU POINT QSI ETA POUR ELEMENTS DKQ ET DSQ
!     ------------------------------------------------------------------
    real(kind=8) :: vj11, vj12, vj21, vj22, peta, meta, pqsi, mqsi
!     ------------------------------------------------------------------
!
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
    bm(1,1) = - meta * vj11 - mqsi * vj12
    bm(1,2) = 0.d0
    bm(1,3) = meta * vj11 - pqsi * vj12
    bm(1,4) = 0.d0
    bm(1,5) = peta * vj11 + pqsi * vj12
    bm(1,6) = 0.d0
    bm(1,7) = - peta * vj11 + mqsi * vj12
    bm(1,8) = 0.d0
    bm(2,1) = 0.d0
    bm(2,2) = - meta * vj21 - mqsi * vj22
    bm(2,3) = 0.d0
    bm(2,4) = meta * vj21 - pqsi * vj22
    bm(2,5) = 0.d0
    bm(2,6) = peta * vj21 + pqsi * vj22
    bm(2,7) = 0.d0
    bm(2,8) = - peta * vj21 + mqsi * vj22
    bm(3,1) = bm(2,2)
    bm(3,2) = bm(1,1)
    bm(3,3) = bm(2,4)
    bm(3,4) = bm(1,3)
    bm(3,5) = bm(2,6)
    bm(3,6) = bm(1,5)
    bm(3,7) = bm(2,8)
    bm(3,8) = bm(1,7)
!
end subroutine
