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

subroutine tail3d(l3, t33, n33, vsige33)
! person_in_charge: etienne.grimal at edf.fr
!=====================================================================
!=====================================================================
    implicit none
!     declaration externes
    real(kind=8) :: l3(3), t33(3, 3), n33(3, 3), vsige33(3, 3)
!     declaration locale
    real(kind=8) :: x(3), sn, a(3, 3)
    integer :: i, j, k
!
    a(1,1) = t33(1,1)
    a(1,2) = t33(2,2)
    a(1,3) = t33(3,3)
    a(2,1) = t33(1,2)
    a(2,2) = t33(1,3)
    a(2,3) = t33(2,3)
    a(3,1) = n33(1,1)
    a(3,2) = n33(2,2)
    a(3,3) = n33(3,3)
    do k = 1, 3
        sn=0.d0
        do i = 1, 3
            x(i)=0.d0
            do j = 1, 3
                x(i)=x(i)+a(i,j)*vsige33(j,k)
            end do
!        sn=sn+x(i)*vsige33(i,k)
            sn=sn+x(i)*x(i)
        end do
!
!       l3(k)=2.d0/sqrt(abs(sn))
        l3(k)=2.d0/sqrt(sn)
!      print*,'l3(',k,')=',l3(k)
    end do
end subroutine
