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

subroutine eclaco(ipg, mxnbn2, connx, nbno2, i1,&
                  i2, i3, i4, i5, i6,&
                  i7, i8)
    implicit   none
    integer :: mxnbn2
    integer :: connx(mxnbn2, *)
    integer :: nbno2(*), work(8), k
    integer :: ipg, i1, i2, i3, i4, i5, i6, i7, i8
!
    work(1)=i1
    work(2)=i2
    work(3)=i3
    work(4)=i4
    work(5)=i5
    work(6)=i6
    work(7)=i7
    work(8)=i8
    do 1, k=1,nbno2(ipg)
    connx(k,ipg)=work(k)
    1 end do
!
end subroutine
