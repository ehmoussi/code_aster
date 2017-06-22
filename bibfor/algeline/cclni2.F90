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

subroutine cclni2(col1, col2, n, d1, d2,&
                  coef1, t1, t2, eps, ier)
! person_in_charge: olivier.boiteau at edf.fr
!     VERSION COMPLEXE DE COLNI2
    implicit none
    integer :: n, ier
    complex(kind=8) :: col1(n), col2(n), d1, d2, coef1, t1(n), t2(n)
    real(kind=8) :: eps
!
    integer :: i
    if (abs(d1) .le. eps .or. abs(d2) .le. eps) then
        ier = 1
    else
        do 110 i = 1, n
            t1(i) = col1(i)
            col1(i) = t1(i)/d1
            t2(i) = col2(i) - coef1*col1(i)
            col2(i) = t2(i)/d2
110      continue
    endif
end subroutine
