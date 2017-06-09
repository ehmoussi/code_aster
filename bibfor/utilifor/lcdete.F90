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

subroutine lcdete(a, deta)
    implicit none
!       DETERMINANT D UNE MATRICE EN FONCTION DE LA MODELISATION
!       3D   : A = A11, A22, A33, RAC2 A12, RAC2 A13, RAC2 A23
!       D_PLAN OU AXIS A = A11, A22, A33, RAC2 A12
!       IN  A      :  MATRICE
!       OUT LCDETE :  DETERMINANT
!       ----------------------------------------------------------------
    integer :: n, nd
    real(kind=8) :: a(6), deta, invrc2
    common /tdim/   n , nd
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    invrc2 = 1.d0 / sqrt(2.d0)
!
    if (n .eq. 6) then
        deta = a(1)*a(2)*a(3) + invrc2*a(4)*a(5)*a(6) - ( a(3)*a(4)*a( 4)+a(2)*a(5)*a(5)+a(1)*a(6&
               &)*a(6) )/2.d0
    endif
!
    if (n .eq. 4) then
        deta = a(1)*a(2)*a(3) - a(3)*a(4)*a(4)/2.d0
    endif
!
end subroutine
