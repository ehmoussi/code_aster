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
    subroutine ss6bgl(resi, kpg, geom, ipoids, idfde, icoopg, pgl, jac, bg)
        aster_logical, intent(in) :: resi
        integer, intent(in) :: kpg
        real(kind=8), intent(in) :: geom(3,6)
        integer, intent(in) :: ipoids
        integer, intent(in) :: idfde
        integer, intent(in) :: icoopg
        real(kind=8), intent(in) :: pgl(3,3)
        real(kind=8), intent(out) :: jac
        real(kind=8), intent(out) :: bg(6,18)
    end subroutine ss6bgl
end interface
