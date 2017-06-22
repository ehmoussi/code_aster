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
    subroutine nmsui3(ds_print     , field_disc, nb_elem  , nb_node      , nb_poin       ,&
                      nb_spoi      , nb_cmp    , type_extr, type_extr_cmp, type_extr_elem,&
                      list_elem    , work_node , work_elem, field        , field_s       ,&
                      i_dof_monitor)
        use NonLin_Datastructure_type
        integer, intent(in) :: nb_node
        integer, intent(in) :: nb_elem
        integer, intent(in) :: nb_poin
        integer, intent(in) :: nb_spoi
        integer, intent(in) :: nb_cmp
        character(len=24), intent(in) :: list_elem
        character(len=19), intent(in) :: field
        character(len=4), intent(in) :: field_disc
        character(len=24), intent(in) :: field_s
        type(NL_DS_Print), intent(inout) :: ds_print
        character(len=8), intent(in) :: type_extr
        character(len=8), intent(in) :: type_extr_elem
        character(len=8), intent(in) :: type_extr_cmp
        character(len=19), intent(in) :: work_node
        character(len=19), intent(in) :: work_elem
        integer, intent(inout) :: i_dof_monitor
    end subroutine nmsui3
end interface
