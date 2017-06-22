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
    subroutine load_list_info(load_empty  , nb_load    , v_load_name, v_load_info,&
                              lload_name_ , lload_info_,&
                              list_load_  ,&
                              list_nbload_, list_name_)
        integer, intent(out) :: nb_load
        aster_logical, intent(out) :: load_empty
        character(len=24), pointer, intent(out) :: v_load_name(:)
        integer, pointer, intent(out) :: v_load_info(:)
        character(len=19), optional, intent(in) :: list_load_
        character(len=*), optional, intent(in) :: lload_name_
        character(len=*), optional, intent(in) :: lload_info_
        character(len=*), optional, target, intent(in) :: list_name_(*)
        integer, optional, intent(in) :: list_nbload_
    end subroutine load_list_info
end interface
