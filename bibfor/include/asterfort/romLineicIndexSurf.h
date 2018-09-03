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
!
interface
    subroutine romLineicIndexSurf(tole         ,&
                                  nb_node      , coor_node1  , coor_node2  ,&
                                  nb_node_slice, coor_node_s1, coor_node_s2,&
                                  node_in_slice)
        real(kind=8), intent(in) :: tole
        integer, intent(in) :: nb_node
        real(kind=8), intent(in) :: coor_node1(nb_node)
        real(kind=8), intent(in) :: coor_node2(nb_node)
        integer, intent(in) :: nb_node_slice
        real(kind=8), intent(in) :: coor_node_s1(nb_node_slice)
        real(kind=8), intent(in) :: coor_node_s2(nb_node_slice)
        integer, intent(out) :: node_in_slice(nb_node)
    end subroutine romLineicIndexSurf
end interface
