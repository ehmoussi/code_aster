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
    subroutine equa_print(mesh         , i_equa   , type_equa, name_node   , name_cmp,&
                          name_cmp_lagr, name_subs, nume_link, nb_node_lagr, list_node_lagr,&
                          ligrel)
        character(len=8), intent(in) :: mesh
        character(len=1), intent(in) :: type_equa
        integer, intent(in) :: i_equa
        character(len=8), intent(in) :: name_node
        character(len=8), intent(in) :: name_cmp
        character(len=8), intent(in) :: name_cmp_lagr
        character(len=8), intent(in) :: name_subs
        integer, intent(in) :: nume_link
        integer, intent(in) :: nb_node_lagr
        integer, pointer, intent(in) :: list_node_lagr(:)
        character(len=8), intent(in) :: ligrel
    end subroutine equa_print
end interface
