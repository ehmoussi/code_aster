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
    subroutine ddr_prep(ds_para, v_list_prim, v_list_dual, v_list_rid, nb_node_rid)
        use Rom_Datastructure_type
        type(ROM_DS_ParaDDR), intent(in) :: ds_para
        integer, intent(in), pointer :: v_list_prim(:)
        integer, intent(in), pointer :: v_list_dual(:)
        integer, intent(out), pointer :: v_list_rid(:)
        integer, intent(out) :: nb_node_rid
    end subroutine ddr_prep
end interface
