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
interface
    subroutine mctg3d(stress, strain, rprops, dsidep, ii, jj, mm, &
                      edge, right, apex, codret)
        real(kind=8) :: stress(6)
        real(kind=8) :: strain(6)
        real(kind=8) :: rprops(6)
        real(kind=8) :: dsidep(6,6)
        real(kind=8) :: edge
        real(kind=8) :: right
        real(kind=8) :: apex
        integer      :: ii
        integer      :: jj
        integer      :: mm
        integer      :: codret
    end subroutine mctg3d
end interface
