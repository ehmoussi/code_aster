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
    subroutine thmMecaElas(option, angl_naut, dtemp,&
                           adcome, dimcon,&
                           deps  , congep, dsdeme, ther_meca)
        character(len=16), intent(in) :: option
        real(kind=8), intent(in) :: dtemp
        integer, intent(in) :: dimcon, adcome
        real(kind=8), intent(in) :: angl_naut(3)
        real(kind=8), intent(in) :: deps(6)
        real(kind=8), intent(inout) :: congep(dimcon)
        real(kind=8), intent(inout) :: dsdeme(6, 6)
        real(kind=8), intent(out) :: ther_meca(6)
    end subroutine thmMecaElas
end interface 
