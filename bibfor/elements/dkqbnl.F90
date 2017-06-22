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

subroutine dkqbnl(qsi, eta, jacob, bnl)
    implicit  none
    real(kind=8) :: qsi, eta, jacob(*), bnl(2, 12)
!
! AJOUT ELEMENTS
!     ------------------------------------------------------------------
!     MATRICE BNL(2,12) MEMBRANE NON-LINEAIRE AU POINT QSI ETA
!                       POUR ELEMENTS DKQ ET DSQ
!     ------------------------------------------------------------------
    real(kind=8) :: vj11, vj12, vj21, vj22
    real(kind=8) :: peta, meta, pqsi, mqsi
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
    bnl(1,1) = - meta * vj11 - mqsi * vj12
    bnl(1,2) = 0.d0
    bnl(1,3) = 0.d0
    bnl(1,4) = meta * vj11 - pqsi * vj12
    bnl(1,5) = 0.d0
    bnl(1,6) = 0.d0
    bnl(1,7) = peta * vj11 + pqsi * vj12
    bnl(1,8) = 0.d0
    bnl(1,9) = 0.d0
    bnl(1,10) = - peta * vj11 + mqsi * vj12
    bnl(1,11) = 0.d0
    bnl(1,12) = 0.d0
!
    bnl(2,1) = - meta * vj21 - mqsi * vj22
    bnl(2,2) = 0.d0
    bnl(2,3) = 0.d0
    bnl(2,4) = meta * vj21 - pqsi * vj22
    bnl(2,5) = 0.d0
    bnl(2,6) = 0.d0
    bnl(2,7) = peta * vj21 + pqsi * vj22
    bnl(2,8) = 0.d0
    bnl(2,9) = 0.d0
    bnl(2,10) = - peta * vj21 + mqsi * vj22
    bnl(2,11) = 0.d0
    bnl(2,12) = 0.d0
!
end subroutine
