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

subroutine t3gbc(xyzl, qsi, eta, bc)
    implicit  none
#include "asterfort/matmul.h"
    real(kind=8) :: qsi, eta
    real(kind=8) :: bc(2, 9), xyzl(3, *)
!
!
!     --------------------------------------------------------
!     MATRICE BC(2,9) AU POINT QSI ETA POUR L'ELEMENT T3GAMMA
!     --------------------------------------------------------
!
    real(kind=8) :: bct1(2, 3), bct2(3, 9)
    real(kind=8) :: zero, un, deux, demi
    real(kind=8) :: x12, y12, x23, y23, x31, y31
    real(kind=8) :: l1, l2, l3
    real(kind=8) :: c2, s2, c3, s3
    real(kind=8) :: q, s2ss3, c3ss3
!
    zero = 0.d0
    un = 1.d0
    deux = 2.d0
    demi = un/deux
!
!   TRIANGLE N1-N2-N3
!
!   COTE 1 COMPOSE DES NOEUDS N1-N2
!
    x12 = xyzl(1,1) - xyzl(1,2)
    y12 = xyzl(2,1) - xyzl(2,2)
    l1 = sqrt(x12*x12+y12*y12)
!
!   COTE 2 COMPOSE DES NOEUDS N2-N3
!
    x23 = xyzl(1,2) - xyzl(1,3)
    y23 = xyzl(2,2) - xyzl(2,3)
    l2 = sqrt(x23*x23+y23*y23)
    c2 = - x23/l2
    s2 = - y23/l2
!
!   COTE 2 COMPOSE DES NOEUDS N3-N1
!
    x31 = xyzl(1,3) - xyzl(1,1)
    y31 = xyzl(2,3) - xyzl(2,1)
    l3 = sqrt(x31*x31+y31*y31)
    c3 = - x31/l3
    s3 = - y31/l3
!
! CALCUL DE LA MATRICE BC
!
    q = un/(c2-s2*c3/s3)
    s2ss3 = s2/s3
    c3ss3 = c3/s3
!
    bct1(1,1) = un - eta
    bct1(1,2) = q*eta
    bct1(1,3) = -s2ss3*q*eta
    bct1(2,1) = - c3ss3 - qsi/(q*s2) + c3ss3*eta
    bct1(2,2) = qsi/s2 - c3ss3*q*eta
    bct1(2,3) = un/s3 - qsi/s3 + c3ss3*s2ss3*q*eta
!
    bct2(1,1) = -un/l1
    bct2(1,2) = demi
    bct2(1,3) = zero
    bct2(1,4) = un/l1
    bct2(1,5) = demi
    bct2(1,6) = zero
    bct2(1,7) = zero
    bct2(1,8) = zero
    bct2(1,9) = zero
!
    bct2(2,1) = zero
    bct2(2,2) = zero
    bct2(2,3) = zero
    bct2(2,4) = -un/l2
    bct2(2,5) = demi*c2
    bct2(2,6) = demi*s2
    bct2(2,7) = un/l2
    bct2(2,8) = demi*c2
    bct2(2,9) = demi*s2
!
    bct2(3,1) = un/l3
    bct2(3,2) = demi*c3
    bct2(3,3) = demi*s3
    bct2(3,4) = zero
    bct2(3,5) = zero
    bct2(3,6) = zero
    bct2(3,7) = -un/l3
    bct2(3,8) = demi*c3
    bct2(3,9) = demi*s3
!
    call matmul(bct1, bct2, 2, 3, 9,&
                bc)
!
end subroutine
