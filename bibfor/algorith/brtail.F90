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

subroutine brtail(l3, t33, n33, vse33)
!
!     ROUTINE ANCIENNEMENT NOMMEE TAIL3D
!
!
!    CALCUL DE LA TAILLE ASSOCIE AU POINT DE GAUSS DANS LA DIRECTION VF3
    implicit none
    real(kind=8) :: l3(3), t33(3, 3), n33(3, 3), vse33(3, 3)
    real(kind=8) :: x(3), y(3), sn, dn
    integer :: i, j, k
!
    do 230 k = 1, 3
        sn=0.d0
        dn=0.d0
        do 240 i = 1, 3
            x(i)=0.d0
            y(i)=0.d0
            do 250 j = 1, 3
                x(i)=x(i)+t33(i,j)*vse33(j,k)
                y(i)=y(i)+n33(i,j)*vse33(j,k)
250          continue
            sn=sn+x(i)*vse33(i,k)
            dn=dn+y(i)*vse33(i,k)
240      continue
        l3(k)=sn/dn
230  end do
end subroutine
