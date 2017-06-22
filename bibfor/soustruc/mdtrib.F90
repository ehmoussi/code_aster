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

subroutine mdtrib(ind, a, n)
    implicit   none
    integer :: n, ind(n)
    real(kind=8) :: a(n)
!
!     CLASSEMENT DE VALEURS (TRI BULLE)
!     ------------------------------------------------------------------
! IN  : N
! IN  : IND
! IN  : A
! OUT : IND
! ----------------------------------------------------------------------
    integer :: i, j, k
!     ------------------------------------------------------------------
!
    do 10 i = n-1, 1, -1
        do 10 j = 1, i
            if (a(ind(j)) .lt. a(ind(j+1))) then
                k=ind(j+1)
                ind(j+1)=ind(j)
                ind(j)=k
            endif
10      continue
end subroutine
