! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
    subroutine cm08nd(nb_node_mesh, add_node_total, prefix, ndinit, &
                      nb_list_elem, nbno_fac, nbfac_modi, nomipe,&
                      mesh_out, coor)
        integer, intent(in) :: nb_list_elem, nbno_fac, nbfac_modi
        integer, intent(in) :: nb_node_mesh, add_node_total, ndinit
        integer, intent(in) :: nomipe(nbno_fac, nbfac_modi*nb_list_elem)
        real(kind=8), intent(inout) :: coor(3, *)
        character(len=8) , intent(in) :: prefix
        character(len=8), intent(in) :: mesh_out
    end subroutine cm08nd
end interface
