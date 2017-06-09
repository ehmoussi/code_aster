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
    subroutine xrell1(tabl_node   , nb_edge, node_sele, nb_node_sele, sdline_crack,&
                      tabai, l_ainter)
        integer, intent(in) :: nb_edge
        integer, intent(in) :: nb_node_sele
        integer, intent(in) :: tabl_node(3, nb_edge)
        integer, intent(inout) :: node_sele(nb_edge)
        character(len=14), intent(in) :: sdline_crack
        aster_logical, intent(in) :: l_ainter
        character(len=19) :: tabai  
    end subroutine xrell1
end interface
