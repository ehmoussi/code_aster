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
    subroutine liscli(list_load  , i_load      , nb_info_maxi, list_info_type, load_namez,&
                      load_funcz , nb_info_type, i_neum_lapl)
        character(len=19), intent(in) :: list_load
        integer, intent(in) :: i_load
        integer, intent(in) :: nb_info_maxi
        character(len=24), intent(inout) :: list_info_type(nb_info_maxi)
        character(len=*), intent(out) :: load_namez
        character(len=*), intent(out) :: load_funcz
        integer, intent(out) :: nb_info_type
        integer, intent(out) :: i_neum_lapl
    end subroutine liscli
end interface
