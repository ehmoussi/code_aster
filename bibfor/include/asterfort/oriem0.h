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
    subroutine oriem0(kdim, type, coor, lino1, nbno1,&
                      lino2, nbno2, lino3, nbno3, ipos,&
                      indmai)
        character(len=2), intent(in) :: kdim
        character(len=8), intent(in) :: type
        real(kind=8), intent(in) :: coor(*)
        integer, intent(in) :: lino1(*)
        integer, intent(in) :: nbno1
        integer, intent(in) :: lino2(*)
        integer, intent(in) :: nbno2
        integer, intent(in) :: lino3(*)
        integer, intent(in) :: nbno3
        integer, intent(out) :: ipos
        integer, intent(out) :: indmai
    end subroutine oriem0
end interface
