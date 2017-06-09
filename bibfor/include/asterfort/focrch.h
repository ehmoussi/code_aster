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
    subroutine focrch(nomfon, resu, noeud, parax, paray,&
                      base, int, intitu, ind, listr,&
                      sst, nsst, ier)
        character(len=19) :: nomfon
        character(len=19) :: resu
        character(len=8) :: noeud
        character(len=16) :: parax
        character(len=16) :: paray
        character(len=1) :: base
        integer :: int
        character(len=24) :: intitu
        integer :: ind
        character(len=19) :: listr
        character(len=8) :: sst
        integer :: nsst
        integer :: ier
    end subroutine focrch
end interface
