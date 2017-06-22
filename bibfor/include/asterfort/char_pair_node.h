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
    subroutine char_pair_node(mesh, nb_node, &
                              list_node_i1, list_node_i2, list_node_o1, list_node_o2, i_error)
        character(len=8), intent(in) :: mesh
        integer, intent(in) :: nb_node
        character(len=24), intent(in) :: list_node_i1
        character(len=24), intent(in) :: list_node_i2
        character(len=24), intent(in) :: list_node_o1
        character(len=24), intent(in) :: list_node_o2
        integer, intent(out) :: i_error
    end subroutine char_pair_node
end interface
