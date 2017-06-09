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
    subroutine vechth(type_ther , model_   , lload_name_, lload_info_, cara_elem_,&
                      mate_     , time_curr, time_      , temp_prev_ , vect_elem_,&
                      varc_curr_, time_move_)
        character(len=4), intent(in) :: type_ther
        character(len=*), intent(in) :: model_
        character(len=*), intent(in) :: lload_name_
        character(len=*), intent(in) :: lload_info_
        character(len=*), intent(in) :: cara_elem_
        real(kind=8), intent(in) :: time_curr
        character(len=*), intent(in) :: time_
        character(len=*), intent(in) :: temp_prev_
        character(len=*), intent(inout) :: vect_elem_
        character(len=*), intent(in) :: mate_
        character(len=*), optional, intent(in) :: varc_curr_
        character(len=*), optional, intent(in) :: time_move_
    end subroutine vechth
end interface
