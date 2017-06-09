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

subroutine vpzrbk(z, h, d, mm, izh,&
                  k, l)
    implicit none
    integer :: mm, izh, k, l
    real(kind=8) :: z(izh, 1), h(izh, 1), d(1)
!     TRANSFORMATION ARRIERE POUR OBTENIR LES VECTEURS (ROUTINE ORTBAK)
!     ------------------------------------------------------------------
!     REFERENCE: F.L. BAUER - J.H. WILKINSON - C. REINSCH
!        HANDBOOK FOR AUTOMATIC COMPUTATION - LINEAR ALGEBRA - VOL.2
!        PAGE 350
!     ------------------------------------------------------------------
    integer :: m, ma, i, j
    real(kind=8) :: g, zero
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    zero = 0.d0
    do 30 m = l-2, k, -1
        ma=m+1
        if (h(ma,m) .ne. zero) then
            do 5 i = m+2, l
                d(i)=h(i,m)
 5          continue
            if (ma .le. l) then
                do 25 j = 1, mm
                    g=zero
                    do 15 i = ma, l
                        g=g+d(i)*z(i,j)
15                  continue
!
                    g = (g/d(ma))/h(ma,m)
                    do 20 i = ma, l
                        z(i,j)=z(i,j)+g*d(i)
20                  continue
25              continue
            endif
        endif
30  end do
end subroutine
