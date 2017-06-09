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

subroutine dstbfa(qsi, eta, carat3, bfa)
    implicit  none
    real(kind=8) :: qsi, eta, carat3(*), bfa(3, 3)
!     MATRICE BFA(3,3) AU POINT QSI ETA POUR L'ELEMENT DST
!     ----------------------------------------------------
    real(kind=8) :: vj11, vj12, vj21, vj22
    real(kind=8) :: lmq, lme
    real(kind=8) :: c4, c5, c6, s4, s5, s6
!     ------------------------------------------------------------------
!
    lmq = 1.d0 - 2.d0 * qsi - eta
    lme = 1.d0 - qsi - 2.d0 * eta
    vj11 = carat3( 9)
    vj12 = carat3(10)
    vj21 = carat3(11)
    vj22 = carat3(12)
    c4 = carat3(16)
    c5 = carat3(17)
    c6 = carat3(18)
    s4 = carat3(19)
    s5 = carat3(20)
    s6 = carat3(21)
!
    bfa(1,1) = 4.d0*( vj11*lmq - vj12*qsi)*c4
    bfa(1,2) = 4.d0*( vj11*eta + vj12*qsi)*c5
    bfa(1,3) = 4.d0*(-vj11*eta + vj12*lme)*c6
    bfa(2,1) = 4.d0*( vj21*lmq - vj22*qsi)*s4
    bfa(2,2) = 4.d0*( vj21*eta + vj22*qsi)*s5
    bfa(2,3) = 4.d0*(-vj21*eta + vj22*lme)*s6
    bfa(3,1) = 4.d0*(lmq*(vj21*c4 + vj11*s4)-qsi*(vj22*c4 + vj12*s4))
    bfa(3,2) = 4.d0*(eta*(vj21*c5 + vj11*s5)+qsi*(vj22*c5 + vj12*s5))
    bfa(3,3) =-4.d0*(eta*(vj21*c6 + vj11*s6)-lme*(vj22*c6 + vj12*s6))
!
end subroutine
