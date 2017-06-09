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

subroutine ccl11j(fronti, frn, n, t)
! person_in_charge: olivier.boiteau at edf.fr
! VERSION COMPLEXE DE COL11J
    implicit none
    integer :: n
    complex(kind=8) :: fronti(*), t(n), frn(*)
!
    integer :: i, j, ic1, id1, jd1, l
    ic1 = 2
    l = n
    jd1 = 1
    do 120 j = 1, n
        id1 = ic1
        do 110 i = 1, l
            frn(jd1) = frn(jd1) - t(j)*fronti(id1)
            jd1 = jd1 + 1
            id1 = id1 + 1
110      continue
        l = l - 1
        ic1 = ic1 + 1
120  end do
end subroutine
