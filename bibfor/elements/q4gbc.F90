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

subroutine q4gbc(qsi, eta, jacob, caraq4, bc)
    implicit  none
    real(kind=8) :: qsi, eta, jacob(*), caraq4(*), bc(2, 12)
!     MATRICE BC(2,12) AU POINT QSI ETA POUR L'ELEMENT Q4GAMMA
!     --------------------------------------------------------
    integer :: j
    real(kind=8) :: vj11, vj12, vj21, vj22, peta, meta, pqsi, mqsi
    real(kind=8) :: x5, x6, x7, x8, y5, y6, y7, y8
    real(kind=8) :: bqsi(12), beta(12)
!     ------------------------------------------------------------------
    vj11 = jacob(1)
    vj12 = jacob(2)
    vj21 = jacob(3)
    vj22 = jacob(4)
!
    x5 = caraq4(1)
    x6 = caraq4(2)
    x7 = caraq4(3)
    x8 = caraq4(4)
    y5 = caraq4(5)
    y6 = caraq4(6)
    y7 = caraq4(7)
    y8 = caraq4(8)
!
    peta = (1.d0 + eta) / 8.d0
    meta = (1.d0 - eta) / 8.d0
    pqsi = (1.d0 + qsi) / 8.d0
    mqsi = (1.d0 - qsi) / 8.d0
!     --------- CALCUL DE BQSI -----------------------
    bqsi( 1) = -2.d0 * meta
    bqsi( 2) = x5 * meta
    bqsi( 3) = y5 * meta
    bqsi( 4) = 2.d0 * meta
    bqsi( 5) = x5 * meta
    bqsi( 6) = y5 * meta
    bqsi( 7) = 2.d0 * peta
    bqsi( 8) = - x7 * peta
    bqsi( 9) = - y7 * peta
    bqsi(10) = -2.d0 * peta
    bqsi(11) = - x7 * peta
    bqsi(12) = - y7 * peta
    beta( 1) = -2.d0 * mqsi
    beta( 2) = - x8 * mqsi
    beta( 3) = - y8 * mqsi
    beta( 4) = -2.d0 * pqsi
    beta( 5) = x6 * pqsi
    beta( 6) = y6 * pqsi
    beta( 7) = 2.d0 * pqsi
    beta( 8) = x6 * pqsi
    beta( 9) = y6 * pqsi
    beta(10) = 2.d0 * mqsi
    beta(11) = - x8 * mqsi
    beta(12) = - y8 * mqsi
!     --------------------- CALCUL DE BC ------------------------------
    do 100 j = 1, 12
        bc(1,j) = vj11 * bqsi(j) + vj12 * beta(j)
        bc(2,j) = vj21 * bqsi(j) + vj22 * beta(j)
!
100  end do
end subroutine
