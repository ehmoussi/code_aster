! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
#include "asterf_types.h"
!
interface
    subroutine romCreateNodeFromEquation(mesh       , field_rom   ,&
                                         v_list_node, nb_list_node, nb_cmp_node_)
        character(len=8), intent(in) :: mesh
        character(len=24), intent(in) :: field_rom
        integer, pointer, optional :: v_list_node(:)
        integer, intent(out) :: nb_list_node
        integer, optional, intent(out) :: nb_cmp_node_
    end subroutine romCreateNodeFromEquation
end interface
