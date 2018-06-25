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

subroutine apcoor(jv_geom  , elem_type, elem_nume, elem_coor,elem_nbnode,&
                  elem_code, elem_dime, v_mesh_connex, v_connex_lcum)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
!
!
    integer, intent(in) :: jv_geom
    character(len=8), intent(in) :: elem_type
    integer, intent(in) :: elem_nume
    real(kind=8), intent(out) :: elem_coor(27)
    integer, intent(out) :: elem_nbnode
    character(len=8), intent(out) :: elem_code
    integer, intent(out) :: elem_dime
    integer, pointer :: v_mesh_connex(:)
    integer, pointer :: v_connex_lcum(:)  
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Pairing segment to segment
!
! Get informations about element
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  jv_geom          : JEVEUX adress to updated geometry
! In  elem_type        : geometric type of element
! In  elem_nume        : index in mesh datastructure of current element
! Out elem_coor        : coordinates of nodes for current element
! Out elem_nbnode      : number of node for current element
! Out elem_code        : code of current element
! Out elem_dime        : dimension of current element
!
! --------------------------------------------------------------------------------------------------
!
    integer :: node_nume
    integer :: i_node, i_dime
    aster_logical:: debug
!
! --------------------------------------------------------------------------------------------------
!
    debug=.false.
    elem_coor(1:27) = 0.d0
!
    select case (elem_type)
        case('SEG2')
            elem_code   = 'SE2'
            elem_nbnode = 2
            elem_dime   = 2
        case('SEG3')
            elem_code   = 'SE3'
            elem_nbnode = 3
            elem_dime   = 2
        case('TRIA3')
            elem_code   = 'TR3'
            elem_nbnode = 3
            elem_dime   = 3
        case('TRIA6')
            elem_code   = 'TR6'
            elem_nbnode = 6
            elem_dime   = 3
        case('QUAD4')
            elem_code   = 'QU4'
            elem_nbnode = 4
            elem_dime   = 3
        case('QUAD8')
            elem_code   = 'QU8'
            elem_nbnode = 8
            elem_dime   = 3
        case('QUAD9')
            elem_code   = 'QU9'
            elem_nbnode = 9
            elem_dime   = 3
        case default
            ASSERT(.false.)
    end select
!
    do i_node = 1, elem_nbnode
        node_nume = v_mesh_connex(v_connex_lcum(elem_nume)-1+i_node)
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
