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
    subroutine prexel(champ, ioc, mamax, nomax, ispmax,&
                      cmpmax, valmax, mamin, nomin, ispmin,&
                      cmpmin, valmin, maamax, noamax, isamax,&
                      cmamax, vaamax, maamin, noamin, isamin,&
                      cmamin, vaamin)
        character(len=*) :: champ
        integer :: ioc
        character(len=8) :: mamax
        character(len=8) :: nomax
        integer :: ispmax
        character(len=8) :: cmpmax
        real(kind=8) :: valmax
        character(len=8) :: mamin
        character(len=8) :: nomin
        integer :: ispmin
        character(len=8) :: cmpmin
        real(kind=8) :: valmin
        character(len=8) :: maamax
        character(len=8) :: noamax
        integer :: isamax
        character(len=8) :: cmamax
        real(kind=8) :: vaamax
        character(len=8) :: maamin
        character(len=8) :: noamin
        integer :: isamin
        character(len=8) :: cmamin
        real(kind=8) :: vaamin
    end subroutine prexel
end interface
