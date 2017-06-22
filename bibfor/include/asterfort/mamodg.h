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
    subroutine mamodg(model, stolci, nomres, itxsto, itysto,&
                      itzsto, iprsto, iadirg, nbmo, max,&
                      may, maz, nbloc)
        character(len=2) :: model
        character(len=19) :: stolci
        character(len=8) :: nomres
        integer :: itxsto
        integer :: itysto
        integer :: itzsto
        integer :: iprsto
        integer :: iadirg
        integer :: nbmo
        character(len=19) :: max
        character(len=19) :: may
        character(len=19) :: maz
        integer :: nbloc
    end subroutine mamodg
end interface
