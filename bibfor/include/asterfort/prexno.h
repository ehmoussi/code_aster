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
    subroutine prexno(champ, ioc, nomax, cmpmax, valmax,&
                      nomin, cmpmin, valmin, noamax, cmamax,&
                      vaamax, noamin, cmamin, vaamin)
        character(len=*) :: champ
        integer :: ioc
        character(len=8) :: nomax
        character(len=8) :: cmpmax
        real(kind=8) :: valmax
        character(len=8) :: nomin
        character(len=8) :: cmpmin
        real(kind=8) :: valmin
        character(len=8) :: noamax
        character(len=8) :: cmamax
        real(kind=8) :: vaamax
        character(len=8) :: noamin
        character(len=8) :: cmamin
        real(kind=8) :: vaamin
    end subroutine prexno
end interface
