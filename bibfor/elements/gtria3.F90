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

subroutine gtria3(xyzl, carat3)
    implicit none
    real(kind=8) :: xyzl(3, *), carat3(*)
!     GRANDEURS GEOMETRIQUES ET JACOBIEN SUR LE TRIA3
!     ------------------------------------------------------------------
    real(kind=8) :: x21, x32, x13, y21, y32, y13
!     ------------------------------------------------------------------
    x21 = xyzl(1,2) - xyzl(1,1)
    x32 = xyzl(1,3) - xyzl(1,2)
    x13 = xyzl(1,1) - xyzl(1,3)
    y21 = xyzl(2,2) - xyzl(2,1)
    y32 = xyzl(2,3) - xyzl(2,2)
    y13 = xyzl(2,1) - xyzl(2,3)
    carat3(1) = x21
    carat3(2) = x32
    carat3(3) = x13
    carat3(4) = y21
    carat3(5) = y32
    carat3(6) = y13
!     -------------- JACOBIEN -----------------------------------------
    carat3(7) = - x21 * y13 + y21 * x13
!     ------------ AIRE DU TRIANGLE -----------------------------------
    carat3(8) = carat3(7)/2.d0
!     ------- MATRICE JACOBIENNE INVERSE ------------------------------
    carat3( 9) = - y13 / carat3(7)
    carat3(10) = - y21 / carat3(7)
    carat3(11) = x13 / carat3(7)
    carat3(12) = x21 / carat3(7)
!     --------- LONGUEURS DES COTES -----------------------------------
    carat3(13) = sqrt(x21*x21 + y21*y21)
    carat3(14) = sqrt(x32*x32 + y32*y32)
    carat3(15) = sqrt(x13*x13 + y13*y13)
!     --------- COSINUS DIRECTEURS -------------------------------------
    carat3(16) = x21 / carat3(13)
    carat3(17) = x32 / carat3(14)
    carat3(18) = x13 / carat3(15)
    carat3(19) = y21 / carat3(13)
    carat3(20) = y32 / carat3(14)
    carat3(21) = y13 / carat3(15)
end subroutine
