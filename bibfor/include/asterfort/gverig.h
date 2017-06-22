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
    subroutine gverig(nocc, chfond, taillr, config,&
                      lobj2, nomno, coorn, trav1, trav2,&
                      trav3, trav4)
        integer :: nocc
        character(len=24) :: chfond
        character(len=24) :: taillr
        character(len=8) :: config
        integer :: lobj2
        character(len=24) :: nomno
        character(len=24) :: coorn
        character(len=24) :: trav1
        character(len=24) :: trav2
        character(len=24) :: trav3
        character(len=24) :: trav4
    end subroutine gverig
end interface
