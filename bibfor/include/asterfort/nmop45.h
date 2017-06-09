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
    subroutine nmop45(matrig, matgeo, defo, option, nfreq,&
                      cdsp, bande, mod45, ddlexc, nddle,&
                      modes, modes2, ddlsta, nsta)
        character(len=19) :: matrig
        character(len=19) :: matgeo
        integer :: defo
        character(len=16) :: option
        integer :: nfreq
        integer :: cdsp
        real(kind=8) :: bande(2)
        character(len=4) :: mod45
        character(len=24) :: ddlexc
        integer :: nddle
        character(len=8) :: modes
        character(len=8) :: modes2
        character(len=24) :: ddlsta
        integer :: nsta
    end subroutine nmop45
end interface
