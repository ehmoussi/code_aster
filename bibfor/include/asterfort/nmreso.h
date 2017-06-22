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
    subroutine nmreso(fonact, cndonn, cnpilo, cncine, solveu,&
                      maprec, matass, depso1, depso2, rescvg)
        integer :: fonact(*)
        character(len=19) :: cndonn
        character(len=19) :: cnpilo
        character(len=19) :: cncine
        character(len=19) :: solveu
        character(len=19) :: maprec
        character(len=19) :: matass
        character(len=19) :: depso1
        character(len=19) :: depso2
        integer :: rescvg
    end subroutine nmreso
end interface
