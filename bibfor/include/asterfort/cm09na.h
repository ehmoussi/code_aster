! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
    subroutine cm09na(mesh_in     ,&
                      nb_node_mesh, nb_list_elem, list_elem,&
                      nb_node_face, nfmax, nb_node_add,&
                      nbno_fac, nbfac_modi,&
                      milieu, nomima, nomipe, nobary,&
                      add_node_total_face, add_node_total_bary)
        character(len=8), intent(in) :: mesh_in
        integer, intent(in) :: nb_list_elem, list_elem(nb_list_elem)
        integer, intent(in) :: nb_node_mesh, nb_node_face, nfmax
        integer, intent(in) :: nb_node_add, nbno_fac, nbfac_modi
        integer, intent(inout) :: milieu(nb_node_face, nfmax, nb_node_mesh)
        integer, intent(inout) :: nomima(nb_node_add, nb_list_elem)
        integer, intent(inout) :: nomipe(nbno_fac, nbfac_modi*nb_list_elem)
        integer, intent(inout) :: nobary(4, nb_list_elem)
        integer, intent(out) :: add_node_total_face
        integer, intent(out) :: add_node_total_bary
    end subroutine cm09na
end interface
