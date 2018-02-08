! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine romLineicIndexSurf(tole         ,&
                              nb_node      , coor_node1  , coor_node2  ,&
                              nb_node_slice, coor_node_s1, coor_node_s2,&
                              node_in_slice)
!
implicit none
!
real(kind=8), intent(in) :: tole
integer, intent(in) :: nb_node
real(kind=8), intent(in) :: coor_node1(nb_node)
real(kind=8), intent(in) :: coor_node2(nb_node)
integer, intent(in) :: nb_node_slice
real(kind=8), intent(in) :: coor_node_s1(nb_node_slice)
real(kind=8), intent(in) :: coor_node_s2(nb_node_slice)
integer, intent(out) :: node_in_slice(nb_node)
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Utilities
!
! For lineic base - Get index in slice for each node in plane orthogonal to given direction
!
! --------------------------------------------------------------------------------------------------
! 
! In  tole             : tolerance
! In  nb_node          : number of nodes
! In  coor_node1       : first coordinate of nodes in plane orthogonal to given direction
! In  coor_node2       : second coordinate of nodes in plane orthogonal to given direction
! In  nb_node_slice    : number of nodes in slice
! In  coor_node_s1     : first coordinate of nodes for slice in plane orthogonal to given direction
! In  coor_node_s2     : second coordinate of nodes for slice in plane orthogonal to given direction
! Out node_in_slice    : for each node, the index of node in slice
!
! --------------------------------------------------------------------------------------------------
! 
    integer :: i_node, i_node_slice
!
! --------------------------------------------------------------------------------------------------
! 
    do i_node = 1, nb_node
        do i_node_slice = 1, nb_node_slice
            if (abs(coor_node_s1(i_node_slice)-coor_node1(i_node)).lt.tole .and.&
                abs(coor_node_s2(i_node_slice)-coor_node2(i_node)).lt.tole) then
                node_in_slice(i_node) = i_node_slice
                exit
            endif
        enddo
    enddo
        
end subroutine
