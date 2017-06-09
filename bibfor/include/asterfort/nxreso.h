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
    subroutine nxreso(matass, maprec, solver, cnchci, cn2mbr,&
                      chsolu)
        character(len=19), intent(in) :: maprec
        character(len=24), intent(in) :: matass
        character(len=19), intent(in) :: solver
        character(len=24), intent(in) :: cnchci
        character(len=24), intent(in) :: cn2mbr
        character(len=19), intent(in) :: chsolu
    end subroutine nxreso
end interface
