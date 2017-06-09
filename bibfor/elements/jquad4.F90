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

subroutine jquad4(xyzl, qsi, eta, jacob)
    implicit  none
    real(kind=8) :: xyzl(3, *), qsi, eta, jacob(*)
!     JACOBIEN ET LA MATRICE INVERSE AU POINT 'INT' SUR LE QUAD4
!     ------------------------------------------------------------------
    real(kind=8) :: x21, x32, x43, x14, y21, y32, y43, y14
    real(kind=8) :: j11, j12, j21, j22
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
!     ----------- MATRICE JACOBIENNE ----------------------------------
    j11 = (x21 - x43 - eta * (x43 + x21)) / 4.d0
    j12 = (y21 - y43 - eta * (y43 + y21)) / 4.d0
    j21 = (x32 - x14 + qsi * (x32 + x14)) / 4.d0
    j22 = (y32 - y14 + qsi * (y32 + y14)) / 4.d0
!     -------------- JACOBIEN -----------------------------------------
    jacob(1) = j11 * j22 - j12 * j21
!     ------- MATRICE JACOBIENNE INVERSE ------------------------------
    jacob(2) = j22 / jacob(1)
    jacob(3) = - j12 / jacob(1)
    jacob(4) = - j21 / jacob(1)
    jacob(5) = j11 / jacob(1)
!
end subroutine
