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

subroutine dsqlxy(qsi, eta, hlt2, an, depf,&
                  codi, lambda)
    implicit  none
    real(kind=8) :: qsi, eta, codi(*), hlt2(4, 6), an(4, 12), depf(12)
    real(kind=8) :: lambda(4)
!     'LAMBDA' DE L'ELEMENT DE PLAQUE DSQ
!     ------------------------------------------------------------------
    integer :: i, j, k
    real(kind=8) :: pqsi, mqsi, peta, meta
    real(kind=8) :: c(4), s(4)
    real(kind=8) :: ta(6, 4), tb(6, 12)
    real(kind=8) :: blb(4, 12), bla(4, 4), bln(4, 12)
!     ------------------------------------------------------------------
!
!
    do 200 k = 1, 6
        do 201 j = 1, 12
            tb(k,j) = 0.d0
201      continue
200  end do
    tb(3,2) = 0.25d0
    tb(3,5) = -0.25d0
    tb(3,8) = 0.25d0
    tb(3,11) = -0.25d0
    tb(6,3) = 0.25d0
    tb(6,6) = -0.25d0
    tb(6,9) = 0.25d0
    tb(6,12) = -0.25d0
    c(1) = codi(1)
    c(2) = codi(2)
    c(3) = codi(3)
    c(4) = codi(4)
    s(1) = codi(5)
    s(2) = codi(6)
    s(3) = codi(7)
    s(4) = codi(8)
!
    peta = 1.d0 + eta
    meta = 1.d0 - eta
    pqsi = 1.d0 + qsi
    mqsi = 1.d0 - qsi
    do 224 k = 1, 6
        do 225 j = 1, 4
            ta(k,j) = 0.d0
225      continue
224  end do
    ta(1,1) = -meta*c(1)
    ta(1,3) = -peta*c(3)
    ta(2,2) = -pqsi*c(2)
    ta(2,4) = -mqsi*c(4)
    ta(3,1) = qsi*c(1)
    ta(3,2) = -eta*c(2)
    ta(3,3) = -qsi*c(3)
    ta(3,4) = eta*c(4)
    ta(4,1) = -meta*s(1)
    ta(4,3) = -peta*s(3)
    ta(5,2) = -pqsi*s(2)
    ta(5,4) = -mqsi*s(4)
    ta(6,1) = qsi*s(1)
    ta(6,2) = -eta*s(2)
    ta(6,3) = -qsi*s(3)
    ta(6,4) = eta*s(4)
!        -------------- BLA = HLT2.TA ----------------------------
    do 228 i = 1, 4
        do 230 j = 1, 4
            bla(i,j) = 0.d0
            do 232 k = 1, 6
                bla(i,j) = bla(i,j) + hlt2(i,k)*ta(k,j)
232          continue
230      continue
228  end do
!        -------------- BLB = HLT2.TB ----------------------------
    do 236 i = 1, 4
        do 238 j = 1, 12
            blb(i,j) = 0.d0
            do 240 k = 1, 6
                blb(i,j) = blb(i,j) + hlt2(i,k)*tb(k,j)
240          continue
238      continue
236  end do
!        -------- LAMBDA = (BLB + BLA.AN).DEPF ------------------
    do 242 i = 1, 4
        lambda(i) = 0.d0
242  end do
    do 246 i = 1, 4
        do 248 j = 1, 12
            bln(i,j) = 0.d0
            do 250 k = 1, 4
                bln(i,j) = bln(i,j) + bla(i,k)*an(k,j)
250          continue
            lambda(i) = lambda(i) + (blb(i,j)+bln(i,j))*depf(j)
248      continue
246  end do
!
end subroutine
