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
    subroutine nmaret(nbarvz, nb_node, nb_dim, sdline_crack, nb_node_sele,&
                      list_node, list_node_1, list_node_2)
        integer :: nb_dim
        integer :: nbarvz
        integer :: nb_node
        character(len=14) :: sdline_crack
        integer :: nb_node_sele
        character(len=24) :: list_node
        character(len=24) :: list_node_1
        character(len=24) :: list_node_2
    end subroutine nmaret
end interface
