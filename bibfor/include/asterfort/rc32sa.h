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
    subroutine rc32sa(typz, nommat, mati, matj, snpq,&
                      spij, spmeca, kemeca,&
                      kether, saltij, sm, fuij)
        character(len=*) :: typz
        character(len=8) :: nommat
        real(kind=8) :: mati(*)
        real(kind=8) :: matj(*)
        real(kind=8) :: snpq
        real(kind=8) :: spij(2)
        real(kind=8) :: spmeca(2)
        real(kind=8) :: kemeca
        real(kind=8) :: kether
        real(kind=8) :: saltij(2)
        real(kind=8) :: sm
        real(kind=8) :: fuij(2)
    end subroutine rc32sa
end interface
