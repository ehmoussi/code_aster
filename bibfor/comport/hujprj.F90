! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
!
#include "asterfort/assert.h"
!
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
    real(kind=8) :: dd
    real(kind=8) :: tin(6), tou(3), toud(3), p, q
!
    common /tdim/ ndt  , ndi
!
    tou(:) = 0.d0
    toud(:) = 0.d0
!
    j = 1
    ASSERT(ndi >= 3)
    do i = 1, ndi
        if (i .ne. k) then
            tou(j) = tin(i)
            j = j+1
        endif
    enddo
!
    tou(3) = tin(ndt+1-k)
!
    dd = ( tou(1)-tou(2) ) /2.d0
    toud(1) = dd
    toud(2) = -dd
    toud(3) = tou(3)
!
    p = ( tou(1)+tou(2) ) /2.d0
    q = sqrt(dd**2 + (tou(3)**2)/2.d0)
!
end subroutine
