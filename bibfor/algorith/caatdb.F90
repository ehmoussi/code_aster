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

subroutine caatdb(nno, a, d, b, jac,&
                  matuu)
!     CALCUL DE TADB POUR LE HEXA8 STABILISE
!-----------------------------------------------------------------------
    implicit none
    integer :: kk, kkd, n, i, m, j, k, kl, nno, j1
    real(kind=8) :: matuu(1)
    real(kind=8) :: d(6, 6), jac, tmp, sig(6)
    real(kind=8) :: a(6, 3, 8)
    real(kind=8) :: b(6, 3, 8)
!
    do 1 n = 1, nno
        do 2 i = 1, 3
            do 3 kl = 1, 6
                tmp = 0.d0
                do 4 k = 1, 6
                    tmp = tmp + a(k,i,n)*d(k,kl)
 4              continue
                sig(kl) = tmp
 3          continue
!
            kkd = (3* (n-1)+i-1)* (3* (n-1)+i)/2
            do 5 j = 1, 3
                do 6 m = 1, n
                    if (m .eq. n) then
                        j1 = i
                    else
                        j1 = 3
                    endif
!
                    tmp = 0.d0
                    do 7 k = 1, 6
                        tmp = tmp + sig(k)*b(k,j,m)
 7                  continue
!
!   STOCKAGE EN TENANT COMPTE DE LA SYMETRIE
!
                    if (j .le. j1) then
                        kk = kkd + 3* (m-1) + j
                        matuu(kk) = matuu(kk) + tmp*jac
                    endif
!
 6              continue
 5          continue
 2      continue
 1  end do
!
end subroutine
