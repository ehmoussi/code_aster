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
subroutine romLineicIndexList(tole         ,&
                              nb_node      , coor_node ,&
                              nb_slice     , coor_slice,&
                              node_to_slice)
!
implicit none
!
real(kind=8), intent(in) :: tole
integer, intent(in) :: nb_node
real(kind=8), intent(in) :: coor_node(nb_node)
integer, intent(in) :: nb_slice
real(kind=8), intent(in) :: coor_slice(nb_slice)
integer, intent(out) :: node_to_slice(nb_node)
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Utilities
!
! For lineic base - Get index of slice for each node in given direction
!
! --------------------------------------------------------------------------------------------------
!
! In  tole             : tolerance
! In  nb_node          : number of nodes
! In  coor_node        : coordinates of nodes in given direction
! In  nb_slice         : number of slices
! In  coor_slice       : coordinates of slices in given direction
! Out node_to_slice    : for each node, the index of slice
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_node, i_slice
!
! --------------------------------------------------------------------------------------------------
! 
    do i_node = 1, nb_node
        do i_slice = 1, nb_slice
            if (abs(coor_slice(i_slice)-coor_node(i_node)) .lt. tole) then
                node_to_slice(i_node) = i_slice
                exit
            endif
        enddo
    enddo    
!
end subroutine
