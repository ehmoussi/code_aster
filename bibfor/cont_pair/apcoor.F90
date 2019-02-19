! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
subroutine apcoor(v_connex , v_connex_lcum, jv_geom  ,&
                  elem_nume, elem_nbnode  , elem_dime,&
                  elem_coor)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
!
integer, pointer :: v_connex(:)
integer, pointer :: v_connex_lcum(:) 
integer, intent(in) :: jv_geom, elem_nume, elem_nbnode, elem_dime
real(kind=8), intent(out) :: elem_coor(27)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Pairing segment to segment
!
! Get coordinates of element
!
! --------------------------------------------------------------------------------------------------
!
! In  v_connex         : pointer to connectivity of mesh
! In  v_connex_lcum    : pointer to size of connectivity of mesh
! In  jv_geom          : JEVEUX adress to updated geometry
! In  elem_nume        : index in mesh datastructure of current element
! In  elem_nbnode      : number of node for current element
! In  elem_dime        : dimension of current element
! Out elem_coor        : coordinates of nodes for current element
!
! --------------------------------------------------------------------------------------------------
!
    integer :: node_nume, i_node, i_dime
    aster_logical:: debug
!
! --------------------------------------------------------------------------------------------------
!
    debug = ASTER_FALSE
    elem_coor(1:27) = 0.d0
!
    do i_node = 1, elem_nbnode
        node_nume = v_connex(v_connex_lcum(elem_nume)-1+i_node)
        if (debug) then
            write(*,*)"noeud", node_nume
        end if
        do i_dime = 1, elem_dime
            elem_coor(3*(i_node-1)+i_dime) = zr(jv_geom+3*(node_nume-1)+i_dime-1)
            if (debug) then
                write(*,*) i_dime, elem_coor(3*(i_node-1)+i_dime)
            endif
        end do
    end do
!
end subroutine
