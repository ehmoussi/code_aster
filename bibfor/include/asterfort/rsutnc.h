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
interface
    subroutine rsutnc(nomsd, nomsy, nbvale, tabnom, tabord,&
                      nbtrou)
        character(len=*), intent(in) :: nomsd
        character(len=*), intent(in) :: nomsy
        integer, intent(in) :: nbvale
        character(len=*), intent(out) :: tabnom(*)
        integer, intent(out) :: tabord(*)
        integer, intent(out) :: nbtrou
    end subroutine rsutnc
end interface
