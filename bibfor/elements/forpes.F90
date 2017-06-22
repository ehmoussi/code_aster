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

subroutine forpes(intsn, nb1, xr, rho, epais,&
                  vpesan, rnormc, vecl1)
    implicit none
!
    integer :: intsn, nb1, intsx
    real(kind=8) :: wgt, rho
    real(kind=8) :: xr(*), vpesan(3), vecl1(42)
!
!-----------------------------------------------------------------------
    integer :: i, i1, i2, l1
    real(kind=8) :: epais, rnormc
!-----------------------------------------------------------------------
    wgt=xr(127-1+intsn)
!
    l1=135
    intsx=8*(intsn-1)
!
    i1=l1+intsx
!
    do 10 i = 1, nb1
        i2=5*(i-1)
        vecl1(i2+1)=vecl1(i2+1)+wgt*rho*epais*vpesan(1)*xr(i1+i)*&
        rnormc
        vecl1(i2+2)=vecl1(i2+2)+wgt*rho*epais*vpesan(2)*xr(i1+i)*&
        rnormc
        vecl1(i2+3)=vecl1(i2+3)+wgt*rho*epais*vpesan(3)*xr(i1+i)*&
        rnormc
10  end do
end subroutine
