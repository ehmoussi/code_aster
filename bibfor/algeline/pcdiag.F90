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

subroutine pcdiag(n, icpl, icpc, icpd)
!  CALCULE LE POINTEUT ICPD=ADRESSE DANS CA DU DERNIER COEFF
!  DE L (DIAGONALE A PART)
!-----------------------------------------------------------------------
! aslint: disable=W1304
    implicit none
    integer :: n
    integer(kind=4) :: icpc(*)
    integer :: icpd(n), icpl(0:n)
!-----------------------------------------------------------------------
    integer :: i, k, k1, k2
!-----------------------------------------------------------------------
    k1 = 1
    do 30 i = 1, n
        k2 = icpl(i)
        icpd(i) = k1 - 1
        do 10 k = k1, k2
            if (icpc(k) .lt. i) then
                icpd(i) = k
            else
                goto 20
            endif
10      continue
20      continue
        k1 = k2 + 1
30  end do
!
end subroutine
