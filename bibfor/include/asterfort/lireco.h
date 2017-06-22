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
    subroutine lireco(keywf         , mesh          , model         , i_zone      , list_elem_slav,&
                      list_elem_mast, list_node_slav, list_node_mast, nb_elem_slav, nb_node_slav  ,&
                      nb_elem_mast  , nb_node_mast)
        character(len=8), intent(in) :: mesh
        character(len=8), intent(in) :: model
        character(len=16), intent(in) :: keywf
        integer, intent(in) :: i_zone
        character(len=24), intent(in) :: list_elem_slav
        character(len=24), intent(in) :: list_elem_mast
        character(len=24), intent(in) :: list_node_slav
        character(len=24), intent(in) :: list_node_mast
        integer, intent(out) :: nb_elem_slav
        integer, intent(out) :: nb_node_slav
        integer, intent(out) :: nb_elem_mast
        integer, intent(out) :: nb_node_mast
    end subroutine lireco
end interface
