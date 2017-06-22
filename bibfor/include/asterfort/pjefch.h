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
    subroutine pjefch(corres, ch1, ch2, tychv, prfchn,&
                      prol0, ligrel, base, iret)
        character(len=16) :: corres
        character(len=19) :: ch1
        character(len=19) :: ch2
        character(len=4) :: tychv
        character(len=19) :: prfchn
        character(len=*) :: prol0
        character(len=19) :: ligrel
        character(len=1) :: base
        integer :: iret
    end subroutine pjefch
end interface
