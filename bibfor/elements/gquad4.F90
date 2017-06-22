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

subroutine gquad4(xyzl, caraq4)
    implicit none
    real(kind=8) :: xyzl(3, *), caraq4(*)
!     GRANDEURS GEOMETRIQUES SUR LE QUAD4
!     ------------------------------------------------------------------
    real(kind=8) :: x21, x32, x43, x14, y21, y32, y43, y14
    real(kind=8) :: x31, x42, y31, y42
!     ------------------------------------------------------------------
!     -------- PROJECTION DES COTES ------------------------------------
    x21 = xyzl(1,2) - xyzl(1,1)
    x32 = xyzl(1,3) - xyzl(1,2)
    x43 = xyzl(1,4) - xyzl(1,3)
    x14 = xyzl(1,1) - xyzl(1,4)
    y21 = xyzl(2,2) - xyzl(2,1)
    y32 = xyzl(2,3) - xyzl(2,2)
    y43 = xyzl(2,4) - xyzl(2,3)
    y14 = xyzl(2,1) - xyzl(2,4)
    caraq4(1) = x21
    caraq4(2) = x32
    caraq4(3) = x43
    caraq4(4) = x14
    caraq4(5) = y21
    caraq4(6) = y32
    caraq4(7) = y43
    caraq4(8) = y14
!     -------- PROJECTION DES DIAGONALES -------------------------------
    x31 = xyzl(1,3) - xyzl(1,1)
    x42 = xyzl(1,4) - xyzl(1,2)
    y31 = xyzl(2,3) - xyzl(2,1)
    y42 = xyzl(2,4) - xyzl(2,2)
!     --------- LONGUEURS DES COTES -----------------------------------
    caraq4( 9) = sqrt(x21*x21 + y21*y21)
    caraq4(10) = sqrt(x32*x32 + y32*y32)
    caraq4(11) = sqrt(x43*x43 + y43*y43)
    caraq4(12) = sqrt(x14*x14 + y14*y14)
!     --------- COSINUS DIRECTEURS -------------------------------------
    caraq4(13) = x21 / caraq4( 9)
    caraq4(14) = x32 / caraq4(10)
    caraq4(15) = x43 / caraq4(11)
    caraq4(16) = x14 / caraq4(12)
    caraq4(17) = y21 / caraq4( 9)
    caraq4(18) = y32 / caraq4(10)
    caraq4(19) = y43 / caraq4(11)
    caraq4(20) = y14 / caraq4(12)
!     ----------- AIRE DU QUADRANGLE ----------------------------------
    caraq4(21) = ( x31 * y42 - y31 * x42)/2.d0
!     --------- AIRE DES 4 TRIANGLES -----------------------------------
    caraq4(22) = (- x21 * y14 + y21 * x14)/2.d0
    caraq4(23) = (- x32 * y21 + y32 * x21)/2.d0
    caraq4(24) = (- x43 * y32 + y43 * x32)/2.d0
    caraq4(25) = (- x14 * y43 + y14 * x43)/2.d0
!
end subroutine
