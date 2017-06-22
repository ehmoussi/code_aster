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
    subroutine apcrsd_lac(ds_contact  , sdappa      , mesh,&
                          nt_poin     , nb_cont_elem, nb_cont_node,&
                          nt_elem_node, nb_node_mesh)
        use NonLin_Datastructure_type
        type(NL_DS_Contact), intent(in) :: ds_contact
        character(len=19), intent(in) :: sdappa
        character(len=8), intent(in) :: mesh
        integer, intent(in) :: nt_poin
        integer, intent(in) :: nb_cont_elem
        integer, intent(in) :: nb_cont_node
        integer, intent(in) :: nt_elem_node
        integer, intent(in) :: nb_node_mesh
    end subroutine apcrsd_lac
end interface
