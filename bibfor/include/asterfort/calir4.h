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
    subroutine calir4(noma, lisrel, nono2, ino2, v1,&
                      jconb1, jcocf1, jconu1, ideca1, jconb2,&
                      jcocf2, jconu2, ideca2)
        character(len=8) :: noma
        character(len=19) :: lisrel
        character(len=8) :: nono2
        integer :: ino2
        real(kind=8) :: v1(3)
        integer :: jconb1
        integer :: jcocf1
        integer :: jconu1
        integer :: ideca1
        integer :: jconb2
        integer :: jcocf2
        integer :: jconu2
        integer :: ideca2
    end subroutine calir4
end interface
