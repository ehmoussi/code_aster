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

subroutine gtvois(v_connex  , v_connex_lcum, list_elem, nb_elem   , elem_nume, elem_code,&
                  v_conx_inv, v_inv_lcum   , nb_neigh , list_neigh)
                 
!
implicit none
!
#include "jeveux.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/utlisi.h"
#include "asterfort/jelira.h"
#include "asterfort/assert.h"
!
!
    integer, pointer :: v_connex(:)
    integer, pointer :: v_connex_lcum(:)
    integer, pointer :: v_conx_inv(:)
    integer, pointer :: v_inv_lcum(:)
    integer, intent(in) :: nb_elem
    integer, intent(in) :: list_elem(nb_elem)
    integer, intent(in) :: elem_nume
    character(len=8), intent(in) :: elem_code
    integer, intent(in) :: nb_neigh
    integer, intent(out) :: list_neigh(4)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Pairing segment to segment
!
! Find element' neighbours of current element
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  conx_inve        : name of object for inverse connectivity
! In  nb_elem          : number of elements
! In  list_elem        : list of elements
! In  elem_nume        : index in mesh datastructure of current element
! In  elem_code        : code of current element
! In  nb_neigh         : number of neigbours for current element
! Out list_neigh       : list of index of element's neighbours of current element
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_node, list_node(4), node_1, node_2
    integer :: node_nbelem_1, node_nbelem_2
    integer :: nb_find, elem_find(2)
    integer :: list_node_next(4)
    integer :: i_node, i_neigh, nb_dime
    integer :: a(nb_elem) , b(nb_elem), i
!
! --------------------------------------------------------------------------------------------------
!
    list_neigh(1:4) = 0   
!
! - Get list of nodes of current element
!
    if (elem_code .eq. 'SE2' .or. elem_code .eq. 'SE3') then
        nb_node = 2
        nb_dime = 1 
    elseif (elem_code .eq. 'TR3' .or. elem_code .eq. 'TR6') then
        nb_node = 3
        nb_dime = 2
    elseif (elem_code .eq. 'QU4' .or. elem_code .eq. 'QU8' .or. elem_code .eq. 'QU9') then
        nb_node = 4
        nb_dime = 2
    else
        ASSERT(.false.)
    end if   
    do i_node = 1, nb_node
        list_node(i_node) = v_connex(v_connex_lcum(elem_nume)-1+i_node)
    end do
!
! - Set index of next nodes
!
    do i_node = 2, nb_node
        list_node_next(i_node-1) = i_node
    end do
    list_node_next(nb_node) = 1
!
! - Find neighbours
!
    if (nb_dime.eq.2) then
        do i_neigh = 1,nb_neigh
            nb_find = 0
            node_1  = list_node(i_neigh)
            node_2  = list_node(list_node_next(i_neigh))
            node_nbelem_1=v_inv_lcum(node_1+1) - v_inv_lcum(node_1)
            node_nbelem_2=v_inv_lcum(node_2+1) - v_inv_lcum(node_2)
            do i= 1 , node_nbelem_1
                a(i)=v_conx_inv(v_inv_lcum(node_1)-1+i)
            end do
            do i= 1 , node_nbelem_2
                b(i)=v_conx_inv(v_inv_lcum(node_2)-1+i)
            end do
            call utlisi('INTER'   , a, node_nbelem_1,b, node_nbelem_2,&
                        elem_find , 2            , nb_find)
            ASSERT(nb_find .le. 2)
            ASSERT(nb_find .ge. 1)
            if (nb_find .eq. 2) then
                if (list_elem(elem_find(1)) .eq. elem_nume) then
                    list_neigh(i_neigh) = list_elem(elem_find(2))
                else
                    list_neigh(i_neigh) = list_elem(elem_find(1))
                end if    
            end if
        end do
    elseif (nb_dime .eq. 1) then
        do i_neigh = 1,nb_neigh
            nb_find = 0
            node_1  = list_node(i_neigh)
            node_nbelem_1=v_inv_lcum(node_1+1) - v_inv_lcum(node_1)          
            ASSERT(node_nbelem_1 .le. 2)
            if (node_nbelem_1 .eq. 2) then
                if (list_elem(v_conx_inv(v_inv_lcum(node_1))) .eq. elem_nume) then
                    list_neigh(i_neigh) = list_elem(v_conx_inv(v_inv_lcum(node_1)+1))
                else
                    list_neigh(i_neigh) = list_elem(v_conx_inv(v_inv_lcum(node_1)))
                end if    
            end if
        end do
    else
        ASSERT(.false.)
    end if
!
end subroutine
