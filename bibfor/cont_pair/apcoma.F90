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

subroutine apcoma(mesh, newgeo, elem_nume, elem_nbnode, elem_coor)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: mesh
    character(len=19), intent(in) :: newgeo
    integer, intent(in) :: elem_nume
    integer, intent(in) :: elem_nbnode
    real(kind=8), intent(out) :: elem_coor(27)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Pairing
!
! Get coordinates of current element
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  newgeo           : name of field for geometry update from initial coordinates of nodes
! In  elem_nume        : index of element in mesh datastructure
! In  elem_nbnode      : number of nodes of element
! Out elem_coor        : coordinates of nodes for current element
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: nbnmax = 9
    integer :: node_nume(nbnmax), i_node
    real(kind=8), pointer :: v_newgeo_vale(:) => null()
    integer, pointer :: v_mesh_connex(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    elem_coor(1:27) = 0.d0
    ASSERT(elem_nbnode.gt.0)
    ASSERT(elem_nbnode.le.nbnmax)
!
! - Get absolute index of nodes
!
    call jeveuo(jexnum(mesh//'.CONNEX', elem_nume), 'L', vi = v_mesh_connex)
    do i_node = 1, elem_nbnode
        node_nume(i_node) = v_mesh_connex(i_node)
    end do
!
! - Coordinates of nodes
!
    call jeveuo(newgeo(1:19)//'.VALE', 'L', vr=v_newgeo_vale)
    do i_node = 1, elem_nbnode
        elem_coor(3*(i_node-1)+1) = v_newgeo_vale(3*(node_nume(i_node)-1)+1)
        elem_coor(3*(i_node-1)+2) = v_newgeo_vale(3*(node_nume(i_node)-1)+2)
        elem_coor(3*(i_node-1)+3) = v_newgeo_vale(3*(node_nume(i_node)-1)+3)
    end do
!
end subroutine
