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
    subroutine pjxxut(dim, mocle, moa1, moa2, nbma1,&
                      lima1, nbno2, lino2, ma1, ma2,&
                      nbtmx, nbtm, nutm, elrf)
        integer :: nbtmx
        character(len=2) :: dim
        character(len=*) :: mocle
        character(len=8) :: moa1
        character(len=8) :: moa2
        integer :: nbma1
        integer :: lima1(*)
        integer :: nbno2
        integer :: lino2(*)
        character(len=8) :: ma1
        character(len=8) :: ma2
        integer :: nbtm
        integer :: nutm(nbtmx)
        character(len=8) :: elrf(nbtmx)
    end subroutine pjxxut
end interface
