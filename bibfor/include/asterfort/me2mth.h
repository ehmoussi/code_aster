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
    subroutine me2mth(model_, nb_load, list_name_, cara_elem_,&
                      time_ , temp_  , vect_elem_)
        character(len=*), intent(in) :: model_
        character(len=*), intent(in) :: temp_
        character(len=*), intent(in) :: cara_elem_
        character(len=*), intent(in) :: vect_elem_
        character(len=*), intent(in) :: time_
        character(len=*), intent(in) :: list_name_(*)
        integer, intent(in) :: nb_load
    end subroutine me2mth
end interface
