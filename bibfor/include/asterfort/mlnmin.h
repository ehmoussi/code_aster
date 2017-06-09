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
    subroutine mlnmin(nu, nomp01, nomp02, nomp03, nomp04,&
                      nomp05, nomp06, nomp07, nomp08, nomp09,&
                      nomp10, nomp11, nomp12, nomp13, nomp14,&
                      nomp15, nomp16, nomp17, nomp18, nomp19,&
                      nomp20)
        character(len=14) :: nu
        character(len=24) :: nomp01
        character(len=24) :: nomp02
        character(len=24) :: nomp03
        character(len=24) :: nomp04
        character(len=24) :: nomp05
        character(len=24) :: nomp06
        character(len=24) :: nomp07
        character(len=24) :: nomp08
        character(len=24) :: nomp09
        character(len=24) :: nomp10
        character(len=24) :: nomp11
        character(len=24) :: nomp12
        character(len=24) :: nomp13
        character(len=24) :: nomp14
        character(len=24) :: nomp15
        character(len=24) :: nomp16
        character(len=24) :: nomp17
        character(len=24) :: nomp18
        character(len=24) :: nomp19
        character(len=24) :: nomp20
    end subroutine mlnmin
end interface
