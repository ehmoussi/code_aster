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
    subroutine calmdg(model, modgen, nugene, num, nu,&
                      ma, mate, moint, moflui, ndble,&
                      itxsto, itysto, itzsto, iprsto, nbmo,&
                      iadirg)
        character(len=2) :: model
        character(len=8) :: modgen
        character(len=14) :: nugene
        character(len=14) :: num
        character(len=14) :: nu
        character(len=8) :: ma
        character(len=*) :: mate
        character(len=8) :: moint
        character(len=8) :: moflui
        integer :: ndble
        integer :: itxsto
        integer :: itysto
        integer :: itzsto
        integer :: iprsto
        integer :: nbmo
        integer :: iadirg
    end subroutine calmdg
end interface
