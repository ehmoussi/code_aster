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
    subroutine gtlmex(v_cninv, v_cninv_lcum, nume_node_cl, nb_elem_mast, list_elem_mast ,&
                      list_el_ma_ax, nb_el_ma_ax)
        integer, pointer, intent(in) :: v_cninv(:) 
        integer, pointer, intent(in) :: v_cninv_lcum(:)
        integer, intent(in) :: nume_node_cl
        integer, intent(in) :: nb_elem_mast
        integer, intent(in) :: list_elem_mast(nb_elem_mast)
        integer, intent(out) :: list_el_ma_ax(nb_elem_mast)
        integer, intent(out) :: nb_el_ma_ax
    end subroutine gtlmex
end interface
