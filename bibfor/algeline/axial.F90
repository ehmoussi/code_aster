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

subroutine axial(antisy, vecax)
!
! FONCTION: FORME LE VECTEUR AXIAL 'VECAX' CORRESPONDANT A LA MATRICE
!           ANTISYMETRIQUE 'ANTISY'.
!
!     IN  : ANTISY    : MATRICE ANTISYMETRIQUE D'ORDRE 3
!
!     OUT : VECAX     : VECTEUR D'ORDRE 3
! ------------------------------------------------------------------
    implicit none
    real(kind=8) :: antisy(3, 3), vecax(3)
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    vecax(1) = antisy(3,2)
    vecax(2) = antisy(1,3)
    vecax(3) = antisy(2,1)
end subroutine
