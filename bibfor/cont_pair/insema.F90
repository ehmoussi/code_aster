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

subroutine insema(elem_nbnode , elem_dime, elem_coor  , pair_tole,&
                  xp1         , yp1      , xp2        , yp2      ,&
                  nb_poin_inte, poin_inte, inte_neigh_)
!
implicit none
!
#include "asterfort/assert.h"  
!
! aslint: disable=W1306
!
    integer, intent(in) :: elem_nbnode
    integer, intent(in) :: elem_dime
    real(kind=8), intent(in) :: elem_coor(2,elem_nbnode)
    real(kind=8) :: pair_tole
    real(kind=8), intent(in) :: xp1
    real(kind=8), intent(in) :: yp1
    real(kind=8), intent(in) :: xp2
    real(kind=8), intent(in) :: yp2
    integer, intent(inout) :: nb_poin_inte
    real(kind=8), intent(inout) :: poin_inte(elem_dime-1,16)
    integer, optional, intent(inout) :: inte_neigh_(4)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Pairing segment to segment
!
! Compute intersection between segment and element
!
! --------------------------------------------------------------------------------------------------
!
! In  elem_dime        : dimension of elements
! In  elem_nbnode      : number of nodes of element
! In  elem_coor        : coordinates of nodes for current element
! In  pair_tole        : tolerance for pairing
! In  xp1              : coordinate (xp1,yp1) - (xp2,yp2) of segment
! In  yp1              : coordinate (xp1,yp1) - (xp2,yp2) of segment
! In  xp2              : coordinate (xp1,yp1) - (xp2,yp2) of segment
! In  yp2              : coordinate (xp1,yp1) - (xp2,yp2) of segment
! IO  nb_poin_inte     : number of intersection points
! IO  poin_inte        : list of intersection points
! IO  inte_neigh       : activation of neighbours of intersection
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: a, b, c, d, x1, y1, x2, y2
    real(kind=8) :: t1, t2, det, norm, aux(2)
    integer :: i_node, list_node_next(elem_nbnode)
!
! --------------------------------------------------------------------------------------------------
!
    ASSERT(elem_nbnode .le. 4)
!
! - Initialization of parametric equation of segment
!
    x1 = xp1
    y1 = yp1
    a  = xp2-xp1
    b  = yp2-yp1
!
! - Set index of next nodes
!
    do i_node=2, elem_nbnode
        list_node_next(i_node-1) = i_node
    end do
    list_node_next(elem_nbnode) = 1   
!
! - Loop on edges of element
!
    do i_node = 1, elem_nbnode
!
! ----- Parametric equation of segment
!
        x2 = elem_coor(1,i_node)
        y2 = elem_coor(2,i_node)
        c  = elem_coor(1,list_node_next(i_node))-elem_coor(1,i_node)
        d  = elem_coor(2,list_node_next(i_node))-elem_coor(2,i_node)
!
! ----- Compute intersection
!
        det=b*c-a*d
        if (sqrt(det**2) .gt. pair_tole) then
            t1     = 1/det*(d*(x1-x2)-c*(y1-y2))
            t2     = 1/det*(b*(x1-x2)-a*(y1-y2)) 
            aux(1) = (-t1*a-t2*c)-(x1-x2)
            aux(2) = ( t1*b+t2*d)-(y1-y2)
            norm   = sqrt(aux(1)**2+aux(2)**2)
        else
            t1     = -1.d0
            t2     = -1.d0    
        endif
!
! ----- Test intersection
!
        if (t1.lt. 1.d0+pair_tole .and.&
            t1.gt. 0.d0-pair_tole .and.&
            t2.lt. 1.d0+pair_tole .and.&
            t2.gt. 0.d0-pair_tole) then
            nb_poin_inte = nb_poin_inte+1
            ASSERT(nb_poin_inte.le.16)
            poin_inte(1,nb_poin_inte) = (t2*c+x2+t1*a+x1)/2.d0
            poin_inte(2,nb_poin_inte) = (t2*d+y2+t1*b+y1)/2.d0
            if (present(inte_neigh_)) then
                inte_neigh_(i_node) = 1
            endif
        endif
    end do
end subroutine
