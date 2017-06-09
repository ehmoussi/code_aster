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

subroutine dkqniw(qsi, eta, caraq4, wkq)
    implicit  none
    real(kind=8) :: qsi, eta, caraq4(*), wkq(12)
!     FONCTIONS D'INTERPOLATION DE LA FLECHE POUR L'ELEMENT DKQ
!     ------------------------------------------------------------------
    real(kind=8) :: pqsi, mqsi, peta, meta, qsic, etac
    real(kind=8) :: x5, x6, x7, x8, y5, y6, y7, y8
    real(kind=8) :: n(12)
!     ------------------------------------------------------------------
    x5 = caraq4(1)
    x6 = caraq4(2)
    x7 = caraq4(3)
    x8 = caraq4(4)
    y5 = caraq4(5)
    y6 = caraq4(6)
    y7 = caraq4(7)
    y8 = caraq4(8)
!
    peta = 1.d0 + eta
    meta = 1.d0 - eta
    pqsi = 1.d0 + qsi
    mqsi = 1.d0 - qsi
    etac = 1.d0 - eta * eta
    qsic = 1.d0 - qsi * qsi
!
! ----- FONCTIONS D'INTERPOLATION DANS LE REPERE REDUIT ------------
    n(1) = mqsi * meta / 8.d0 * (qsic + etac - qsi - eta)
    n(2) = mqsi * meta / 8.d0 * qsic
    n(3) = mqsi * meta / 8.d0 * etac
    n(4) = pqsi * meta / 8.d0 * (qsic + etac + qsi - eta)
    n(5) = - pqsi * meta / 8.d0 * qsic
    n(6) = pqsi * meta / 8.d0 * etac
    n(7) = pqsi * peta / 8.d0 * (qsic + etac + qsi + eta)
    n(8) = - pqsi * peta / 8.d0 * qsic
    n(9) = - pqsi * peta / 8.d0 * etac
    n(10) = mqsi * peta / 8.d0 * (qsic + etac - qsi + eta)
    n(11) = mqsi * peta / 8.d0 * qsic
    n(12) = - mqsi * peta / 8.d0 * etac
! ----- FONCTIONS D'INTERPOLATION DANS LE REPERE LOCAL -------------
    wkq(1) = n(1)
    wkq(2) = (- x5*n(2) + x8*n(3)) / 2.d0
    wkq(3) = (- y5*n(2) + y8*n(3)) / 2.d0
    wkq(4) = n(4)
    wkq(5) = (- x5*n(5) - x6*n(6)) / 2.d0
    wkq(6) = (- y5*n(5) - y6*n(6)) / 2.d0
    wkq(7) = n(7)
    wkq(8) = ( x7*n(8) - x6*n(9)) / 2.d0
    wkq(9) = ( y7*n(8) - y6*n(9)) / 2.d0
    wkq(10) = n(10)
    wkq(11) = ( x7*n(11) + x8*n(12)) / 2.d0
    wkq(12) = ( y7*n(11) + y8*n(12)) / 2.d0
!
end subroutine
