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

subroutine hbbmp6(xnoe, b)
!             ELEMENT SHB6 F.ABED-MERAIM, V.D.TRINH 2007               !
!-----------------------------------------------------------------------
    implicit none
!
! Hallquist B Bar Matrix for Prisme 6-node
! Evaluation of [B] bar matrix components in Hallquist form
!
!
! Evaluation of [B] bar matrix components in Hallquist form for SHB6 element.
! [B] bar matrix components are evaluated in position (0,0,0).
!
!
! IN  x        element nodal coordinates
! OUT b        [B] bar matrix
!
#include "asterfort/matini.h"
#include "asterfort/matinv.h"
!
    real(kind=8), intent(in) :: xnoe(18)
    real(kind=8), intent(out) :: b(3,6)
!
    integer :: i, j, k
    real(kind=8) :: dj(3,3), uj(3,3), bhall(3,6), ajac
!
! ......................................................................
!
    data bhall/ 0.5d0, 0.0d0, 0.0d0,&
     &          0.0d0, 0.5d0, 0.0d0,&
     &         -0.5d0,-0.5d0,-0.5d0,&
     &          0.5d0, 0.0d0, 0.0d0,&
     &          0.0d0, 0.5d0, 0.0d0,&
     &         -0.5d0,-0.5d0, 0.5d0/
!
!   Evaluate dj = bhall * transposed(xnoe)
!
    call matini(3, 3, 0.d0, dj)
    do 10 i = 1, 3
        do 11 j = 1, 3
            do 12 k = 1, 6
                dj(j,i)=dj(j,i)+bhall(j,k)*xnoe((k-1)*3+i)
12          continue
11      continue
10  continue
!
    call matinv('S', 3, dj, uj, ajac)
!
!   Evaluate [B] = uj * bhall
!
    call matini(3, 6, 0.d0, b)
    do 20 k = 1, 3
       do 21 j = 1, 3
          do 22 i = 1, 6
             b(j,i)=b(j,i)+uj(j,k)*bhall(k,i)
22        continue
21     continue
20  continue
!
end subroutine
