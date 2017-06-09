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

subroutine cjst(s, t)
    implicit none
!      CALCUL DE T = DET(S)*INV(S)
!       3D   : A = A11, A22, A33, RAC2 A12, RAC2 A13, RAC2 A23
!       D_PLAN OU AXIS A = A11, A22, A33, RAC2 A12
!       IN  S      :  MATRICE
!       OUT T      :  T (SOUS FORME VECTORIELLE AVEC RAC2)
!       ----------------------------------------------------------------
    integer :: n, nd
    real(kind=8) :: s(6), t(6), invrc2
    common /tdim/   n , nd
!
    invrc2 = 1.d0 / sqrt(2.d0)
    if (n .eq. 6) then
        t(1) = ( s(2)*s(3)-0.5d0*s(6)*s(6) )
        t(2) = ( s(1)*s(3)-0.5d0*s(5)*s(5) )
        t(3) = ( s(1)*s(2)-0.5d0*s(4)*s(4) )
        t(4) = ( invrc2*s(5)*s(6)-s(4)*s(3) )
        t(5) = ( invrc2*s(4)*s(6)-s(5)*s(2) )
        t(6) = ( invrc2*s(4)*s(5)-s(6)*s(1) )
    endif
!
    if (n .eq. 4) then
        t(1) = s(2)*s(3)
        t(2) = s(1)*s(3)
        t(3) = ( s(1)*s(2)-0.5d0*s(4)*s(4) )
        t(4) = -s(4)*s(3)
    endif
end subroutine
