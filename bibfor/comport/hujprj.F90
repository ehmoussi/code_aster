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

subroutine hujprj(k, tin, toud, p, q)
    implicit none
!  LOI DE HUJEUX: PROJECTION DANS LE PLAN DEVIATEUR K
!  IN  K        :  DIRECTION K=1 A 3
!      TIN( )   :  TENSEUR A PROJETER (NDIM), EGAL A:
!                     - TENSEUR DES CONTRAINTES DE CAUCHY
!                     - TENSEUR DES DEFORMATIONS
!
!  OUT
!      TOUD  :  DEVIATEUR K (NDIM/2)
!      P     :  COMPOSANTE ISOTROPE K
!      Q     :  NORME DEVIATEUR K
!  ------------------------------------------------------
    integer :: ndt, ndi, i, j, k
    real(kind=8) :: d12, dd, deux
    real(kind=8) :: tin(6), tou(3), toud(3), p, q
!
    common /tdim/ ndt  , ndi
!
    data   d12, deux /0.5d0, 2.d0/
!
    j = 1
    do i = 1, ndi
        if (i .ne. k) then
            tou(j) = tin(i)
            j = j+1
        endif
    enddo
!
    tou(3) = tin(ndt+1-k)
!
    dd = d12*( tou(1)-tou(2) )
    toud(1) = dd
    toud(2) = -dd
    toud(3) = tou(3)
!
    p = d12*( tou(1)+tou(2) )
    q = dd**deux + ((tou(3))**deux)/deux
    q = sqrt(q)
!
end subroutine
