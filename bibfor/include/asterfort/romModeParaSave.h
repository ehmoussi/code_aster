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
    subroutine romModeParaSave(base , i_mode    ,&
                               model, field_name, mode_freq, nume_slice, nb_snap)
        character(len=8), intent(in) :: base
        integer, intent(in) :: i_mode
        character(len=8), intent(in)  :: model
        character(len=24), intent(in) :: field_name
        integer, intent(in)           :: nume_slice
        real(kind=8), intent(in)      :: mode_freq
        integer, intent(in)           :: nb_snap
    end subroutine romModeParaSave
end interface
