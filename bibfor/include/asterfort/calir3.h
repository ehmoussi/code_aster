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
    subroutine calir3(mo, nbma1, lima1, nbno2, lino2,&
                      geom2, corre1, corre2, jlisv1, iocc)
        integer :: nbno2
        integer :: nbma1
        character(len=8) :: mo
        integer :: lima1(nbma1)
        integer :: lino2(nbno2)
        character(len=24) :: geom2
        character(len=16) :: corre1
        character(len=16) :: corre2
        integer :: jlisv1
        integer :: iocc
    end subroutine calir3
end interface
