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
    subroutine dy2mbr(numddl, neq, lischa, freq, vediri,&
                      veneum, vevoch, vassec, j2nd)
        character(len=14) :: numddl
        integer :: neq
        character(len=19) :: lischa
        real(kind=8) :: freq
        character(len=19) :: vediri
        character(len=19) :: veneum
        character(len=19) :: vevoch
        character(len=19) :: vassec
        integer :: j2nd
    end subroutine dy2mbr
end interface
