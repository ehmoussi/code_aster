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
    subroutine xsella(crack       , nb_node_mesh, nb_edge, tabl_node, node_sele,&
                      nb_node_sele)
        character(len=8), intent(in) :: crack
        integer, intent(in) :: nb_node_mesh
        integer, intent(in) :: nb_edge
        integer, intent(in) :: tabl_node(3, nb_edge)
        integer, intent(inout) :: node_sele(nb_edge)
        integer, intent(out) :: nb_node_sele
    end subroutine xsella
end interface
