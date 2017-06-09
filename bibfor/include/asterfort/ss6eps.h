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
    subroutine ss6eps(xe, pgl, kpg, ipoids,&
                      idfde, poids, dfdig, deplm, epsm, deplp, epsp)
        real(kind=8), intent(in) :: xe(*)
        real(kind=8), intent(in) :: pgl(3,3)
        integer, intent(in) :: kpg
        integer, intent(in) :: ipoids
        integer, intent(in) :: idfde
        real(kind=8), intent(out) :: poids
        real(kind=8), intent(out) :: dfdig(6,3)
        real(kind=8), intent(in) :: deplm(*)
        real(kind=8), intent(out) :: epsm(6)
        real(kind=8), optional, intent(in) :: deplp(*)
        real(kind=8), optional, intent(out) :: epsp(6)
    end subroutine ss6eps
end interface
