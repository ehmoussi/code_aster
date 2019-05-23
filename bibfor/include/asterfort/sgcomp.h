! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
    subroutine sgcomp(compor_curr, sigm, ligrel_currz, iret, &
                      type_stop)
        character(len=*), intent(in) :: compor_curr
        character(len=*), intent(in) :: sigm
        character(len=*), intent(in) :: ligrel_currz
        integer, intent(out) :: iret
        character(len=1), optional, intent(in) :: type_stop
    end subroutine sgcomp
end interface
