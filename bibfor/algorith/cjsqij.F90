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

subroutine cjsqij(s, i1, x, q)
    implicit none
!       TENSEUR Q = S - I1 * X
!       IN  N      :  DIMENSION DE S, X, Q
!       IN  S      :  DEVIATEUR
!       IN  I1     :  PREMIER INV.
!       IN  X      :  CENTRE DE LA SURFACE DE CHARGE DEVIATOIRE
!       OUT Q      :  TENSEUR RESULTAT
!       ----------------------------------------------------------------
!
    integer :: ndt, ndi, i
    real(kind=8) :: s(6), i1, x(6), q(6)
!
    common /tdim/   ndt , ndi
    do 1 i = 1, ndt
        q(i) = s(i) - i1*x(i)
 1  continue
!
end subroutine
