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
    subroutine romModeParaRead(base  , i_mode     ,&
                               model_, field_name_, mode_freq_, nume_slice_, nb_snap_)
        character(len=8), intent(in) :: base
        integer, intent(in) :: i_mode
        character(len=8), optional, intent(out)  :: model_
        character(len=24), optional, intent(out) :: field_name_
        integer, optional, intent(out)           :: nume_slice_
        real(kind=8), optional, intent(out)      :: mode_freq_
        integer, optional, intent(out)           :: nb_snap_
    end subroutine romModeParaRead
end interface
