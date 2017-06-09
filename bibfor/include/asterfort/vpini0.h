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
    subroutine vpini0(compex, modes, typcon, solveu, eigsol, matpsc, matopa, veclag,&
                      vecblo, vecrig, vecrer, vecrei, vecrek, vecvp)
        character(len=16) , intent(out) :: compex
        character(len=8)  , intent(out) :: modes
        character(len=16) , intent(out) :: typcon
        character(len=19) , intent(out) :: solveu
        character(len=19) , intent(out) :: eigsol
        character(len=19) , intent(out) :: matpsc
        character(len=19) , intent(out) :: matopa
        character(len=24) , intent(out) :: veclag
        character(len=24) , intent(out) :: vecblo
        character(len=24) , intent(out) :: vecrig
        character(len=24) , intent(out) :: vecrer
        character(len=24) , intent(out) :: vecrei
        character(len=24) , intent(out) :: vecrek
        character(len=24) , intent(out) :: vecvp
    end subroutine vpini0
end interface
