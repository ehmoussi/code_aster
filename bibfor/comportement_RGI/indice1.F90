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

subroutine indice1(i, k, l)
! person_in_charge: etienne.grimal at edf.fr
!=====================================================================
!     indices complementaires dans une matrice carre
!=====================================================================
    implicit none
    integer :: i, k, l
    if (i .eq. 1) then
        k=2
        l=3
    end if
    if (i .eq. 2) then
        k=1
        l=3
    end if
    if (i .eq. 3) then
        k=1
        l=2
    end if
end subroutine
