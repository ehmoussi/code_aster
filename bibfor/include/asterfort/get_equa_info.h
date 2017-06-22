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
    subroutine get_equa_info(nume_ddlz     , i_equa    , type_equa , nume_nodez  , nume_cmpz,&
                             nume_cmp_lagrz, nume_subsz, nume_linkz, nb_node_lagr, list_node_lagr,&
                             ligrelz)
        character(len=*), intent(in) :: nume_ddlz
        integer, intent(in) :: i_equa
        character(len=*), intent(out) :: type_equa
        integer, optional, intent(out) :: nume_nodez
        integer, optional, intent(out) :: nume_cmpz
        integer, optional, intent(out) :: nume_subsz
        integer, optional, intent(out) :: nume_linkz
        integer, optional, intent(out) :: nume_cmp_lagrz
        integer, optional, intent(out) :: nb_node_lagr
        integer, optional, pointer, intent(out) :: list_node_lagr(:)
        character(len=*), optional, intent(out) :: ligrelz
    end subroutine get_equa_info
end interface
