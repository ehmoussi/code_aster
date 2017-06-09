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
    subroutine rbph02(mailla, numddl, chamno, nomgd, neq,&
                      nbnoeu, objve1, ncmp, objve2, objve3,&
                      objve4)
        character(len=8) :: mailla
        character(len=14) :: numddl
        character(len=*) :: chamno
        character(len=8) :: nomgd
        integer :: neq
        integer :: nbnoeu
        character(len=24) :: objve1
        integer :: ncmp
        character(len=24) :: objve2
        character(len=24) :: objve3
        character(len=24) :: objve4
    end subroutine rbph02
end interface
