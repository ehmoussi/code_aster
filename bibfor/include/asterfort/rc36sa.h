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

!
!
interface
    subroutine rc36sa(nommat, mati, matj, snpq, spij,&
                      typeke, spmeca, spther, saltij, sm)
        character(len=8) :: nommat
        real(kind=8) :: mati(*)
        real(kind=8) :: matj(*)
        real(kind=8) :: snpq
        real(kind=8) :: spij
        real(kind=8) :: typeke
        real(kind=8) :: spmeca
        real(kind=8) :: spther
        real(kind=8) :: saltij
        real(kind=8) :: sm
    end subroutine rc36sa
end interface
