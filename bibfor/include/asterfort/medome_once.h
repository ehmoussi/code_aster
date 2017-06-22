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
    subroutine medome_once(result, v_list_store, nb_store, nume_user_,&
                           model_, cara_elem_  , chmate_ , list_load_)
        character(len=8), intent(in) :: result
        integer, pointer, intent(in) :: v_list_store(:)
        integer, intent(in) :: nb_store
        integer, optional, intent(in) :: nume_user_
        character(len=8), optional, intent(out) :: model_
        character(len=8), optional, intent(out) :: cara_elem_
        character(len=24), optional, intent(out) :: chmate_
        character(len=19), optional, intent(out) :: list_load_
    end subroutine medome_once
end interface
