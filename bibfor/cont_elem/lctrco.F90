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

subroutine lctrco(i_tria, tria_node, poin_inte, tria_coor)
!
implicit none
!
#include "asterfort/assert.h"
!
!
    integer, intent(in) :: i_tria
    integer, intent(in) :: tria_node(6, 3)
    real(kind=8), intent(in) :: poin_inte(2, 16)
    real(kind=8), intent(out) :: tria_coor(2, 3)
!
! --------------------------------------------------------------------------------------------------
!
! Contact (LAC) - Elementary computations
!
! Coordinates of current triangle
!
! --------------------------------------------------------------------------------------------------
!
! In  i_tria           : index of current triangle
! In  tria_node        : list of triangles (defined by index of intersection points)
! In  poin_inte        : list (sorted) of intersection points
! Out tria_coor        : coordinates of current triangle
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_node
!
! --------------------------------------------------------------------------------------------------
!
    do i_node=1, 3
        tria_coor(1,i_node) = poin_inte(1,tria_node(i_tria,i_node))
        tria_coor(2,i_node) = poin_inte(2,tria_node(i_tria,i_node))
    end do
!
end subroutine
