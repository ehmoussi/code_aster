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

subroutine forsrg(intsn, nb1, nb2, xr, chgsrg,&
                  rnormc, vectpt, vecl1)
    implicit none
!
    integer :: intsn, nb1, nb2, intsx1
    real(kind=8) :: wgt, rnormc
    real(kind=8) :: xr(*), vecl1(42), chg(6), chgsrg(6, 8)
    real(kind=8) :: vectpt(9, 3, 3)
!
!     EFFORTS SURFACIQUES DONNES DANS LE REPERE GLOBAL
!
!-----------------------------------------------------------------------
    integer :: i, i1, i2, i3, i4, i5, in
    integer :: intsx2, j, k, l1, l2
!-----------------------------------------------------------------------
    wgt=xr(127-1+intsn)
!
    l1=135
    l2=459
    intsx1=8*(intsn-1)
    intsx2=9*(intsn-1)
!
    i1=l1+intsx1
    i2=l2+intsx2
!
!     INTERPOLATION DES CHARGES
!
    do 10 j = 1, 6
        chg(j)=0.d0
        do 20 in = 1, nb1
            chg(j)=chg(j)+chgsrg(j,in)*xr(i1+in)
20      end do
10  end do
!
    do 30 i = 1, nb1
!
        i3=5*(i-1)
        vecl1(i3+1)=vecl1(i3+1)+wgt*chg(1)*xr(i1+i)*rnormc
        vecl1(i3+2)=vecl1(i3+2)+wgt*chg(2)*xr(i1+i)*rnormc
        vecl1(i3+3)=vecl1(i3+3)+wgt*chg(3)*xr(i1+i)*rnormc
!
        do 40 k = 1, 3
            vecl1(i3+4)=vecl1(i3+4)+wgt*chg(3+k)*(-xr(i2+i))*vectpt(i,&
            2,k)
            vecl1(i3+5)=vecl1(i3+5)+wgt*chg(3+k)* xr(i2+i) *vectpt(i,&
            1,k)
40      end do
30  end do
!
    i4=5*nb1+1
    i5=5*nb1+2
    do 50 k = 1, 3
        vecl1(i4) =vecl1(i4)+wgt*chg(3+k)*(-xr(i2+nb2))*vectpt(i,2,k)
        vecl1(i5) =vecl1(i5)+wgt*chg(3+k)* xr(i2+nb2)* vectpt(i,1,k)
50  end do
!
end subroutine
