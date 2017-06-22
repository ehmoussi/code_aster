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

subroutine rot3d(x, sina, cosa, sinb, cosb,&
                 sing, cosg, y)
    implicit none
!  CODE 1083
! GENERATION D'UNE MATRICE DE ROTATION(3 AXES) ANGLES DONNES EN RADIANS
#include "asterfort/pmavec.h"
    real(kind=8) :: rx(3, 3), ry(3, 3), rz(3, 3), rzyx(3, 3), p(3), x(*), y(*)
!-----------------------------------------------------------------------
    integer :: i, j, k, l
    real(kind=8) :: cosa, cosb, cosg, sina, sinb, sing
!-----------------------------------------------------------------------
    rz(1,1)=1.d0
    ry(2,2)=      rz(1,1)
    rx(3,3)=      ry(2,2)
    rx(1,1)= cosa
    rx(1,2)= sina
    rx(2,1)=-sina
    rx(2,2)= cosa
    rx(3,2)=0.d0
    rx(3,1)=      rx(3,2)
    rx(2,3)=      rx(3,1)
    rx(1,3)=      rx(2,3)
    ry(1,1)= cosb
    ry(1,3)=-sinb
    ry(3,1)= sinb
    ry(3,3)= cosb
    ry(3,2)=0.d0
    ry(2,3)=      ry(3,2)
    ry(2,1)=      ry(2,3)
    ry(1,2)=      ry(2,1)
    rz(2,2)= cosg
    rz(2,3)= sing
    rz(3,2)=-sing
    rz(3,3)= cosg
    rz(3,1)=0.d0
    rz(2,1)=      rz(3,1)
    rz(1,3)=      rz(2,1)
    rz(1,2)=      rz(1,3)
    do 10 l = 1, 3
        do 10 k = 1, 3
            if (abs(rx(k,l)) .lt. 1.d-6) rx(k,l)=0.d0
            if (abs(ry(k,l)) .lt. 1.d-6) ry(k,l)=0.d0
            if (abs(rz(k,l)) .lt. 1.d-6) rz(k,l)=0.d0
10      continue
    do 20 j = 1, 3
        do 20 i = 1, 3
            rzyx(i,j)=0.d0
            do 20 k = 1, 3
                p(k)=0.d0
                do 15 l = 1, 3
                    p(k)=p(k)+rz(i,l)*ry(l,k)
15              continue
                rzyx(i,j)=rzyx(i,j)+p(k)*rx(k,j)
20          continue
    call pmavec('ZERO', 3, rzyx, x, y)
end subroutine
