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

subroutine btkb(ndimc, ndimx, nddle, wmatc, btild,&
                wmatcb, ktildi)
    implicit none
!
    integer :: ndimc, nddle
!
    real(kind=8) :: wmatc(ndimc, ndimc), wmatcb(ndimc, ndimx)
    real(kind=8) :: btild(ndimc, ndimx)
    real(kind=8) :: ktildi(ndimx, ndimx)
    integer :: i, j, k, ndimx
!-----------------------------------------------------------------------
!
    do 10 i = 1, ndimc
        do 20 j = 1, nddle
            wmatcb(i,j)=0.d0
            do 30 k = 1, ndimc
                wmatcb(i,j)=wmatcb(i,j)+wmatc(i,k)*btild(k,j)
30          end do
20      end do
10  end do
!
    do 40 i = 1, nddle
        do 50 j = 1, nddle
            ktildi(i,j)=0.d0
            do 60 k = 1, ndimc
                ktildi(i,j)=ktildi(i,j)+btild(k,i)*wmatcb(k,j)
60          end do
50      end do
40  end do
end subroutine
