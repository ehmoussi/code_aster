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
#include "asterf_types.h"
!
interface
    subroutine meacmv(modele, mate, carele, fomult, lischa,&
                      partps, numedd, assmat, solveu, vecass,&
                      matass, maprec, cnchci, base, compor)
        character(len=24) :: modele
        character(len=*) :: mate
        character(len=24) :: carele
        character(len=24) :: fomult
        character(len=19) :: lischa
        real(kind=8) :: partps(3)
        character(len=24) :: numedd
        aster_logical :: assmat
        character(len=19) :: solveu
        character(len=19) :: vecass
        character(len=19) :: matass
        character(len=19) :: maprec
        character(len=24) :: cnchci
        character(len=1) :: base
        character(len=24) :: compor
    end subroutine meacmv
end interface
