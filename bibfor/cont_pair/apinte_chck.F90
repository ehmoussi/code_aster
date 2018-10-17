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
subroutine apinte_chck(proj_tole       , elem_dime     , &
                       elem_mast_nbnode, elem_mast_coor, &
                       elem_slav_nbnode, elem_slav_coor, elem_slav_code,&
                       proj_coor       , mast_norm     , slav_norm     ,&
                       l_inter)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/apdist.h"
!
real(kind=8), intent(in) :: proj_tole
integer, intent(in) :: elem_dime
integer, intent(in) :: elem_mast_nbnode
real(kind=8), intent(in) :: elem_mast_coor(3,9)
integer, intent(in) :: elem_slav_nbnode
real(kind=8), intent(in) :: elem_slav_coor(3,9)
character(len=8), intent(in) :: elem_slav_code
real(kind=8), intent(in) :: proj_coor(elem_dime-1,4)
real(kind=8), intent(in) :: mast_norm(3), slav_norm(3)
aster_logical, intent(out) :: l_inter
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Pairing segment to segment
!
! Check if intersection is void or not
!
! --------------------------------------------------------------------------------------------------
!
! In  proj_tole        : tolerance for projection
! In  elem_dime        : dimension of elements
! In  elem_mast_nbnode : number of nodes of master element
! In  elem_mast_coor   : coordinates of master element
! In  elem_slav_nbnode : number of nodes for slave element
! In  elem_slav_coor   : coordinates of slave element
! In  elem_slav_code   : code of slave element
! In  proj_coor        : projection of master nodes on slave element
! In  mast_norm        : normal for master side
! In  slav_norm        : normal for slave side
! Out l_inter          : .true. if intersection is non-void
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: debug
    real(kind=8) :: noma_coor(3)
    real(kind=8) :: ksi1, ksi2
    real(kind=8) :: dist, vect_pm(3)
    real(kind=8) :: tevapr, dist_sign, sig
    integer :: i_node, i_dime
!
! --------------------------------------------------------------------------------------------------
!
    debug   = ASTER_FALSE
    l_inter = ASTER_TRUE
!
    do i_node = 1, elem_mast_nbnode
! ----- Get coordinates of master nodes
        noma_coor(1:3) = 0.d0
        do i_dime = 1, elem_dime
            noma_coor(i_dime) = elem_mast_coor(i_dime, i_node)
        end do
! ----- Parametric coordinates of projection
        ksi1 = proj_coor(1, i_node)
        if (elem_dime .eq. 3) then
            ksi2 = proj_coor(2, i_node)
        endif
! ----- Compute distance from point to its orthogonal projection
        dist = 0.d0
        call apdist(elem_slav_code, elem_slav_coor, elem_slav_nbnode, ksi1, ksi2,&
                    noma_coor     , dist          , vect_pm)
! ----- Sign of colinear product VECT_PM . NORMAL(slave)
        sig = 0.d0
        if (elem_dime .eq. 3) then
            sig = vect_pm(1)*slav_norm(1)+&
                  vect_pm(2)*slav_norm(2)+&
                  vect_pm(3)*slav_norm(3)
        elseif (elem_dime .eq. 2) then
            sig = vect_pm(1)*slav_norm(1)+&
                  vect_pm(2)*slav_norm(2)
        else
            ASSERT(ASTER_FALSE)
        end if       
        dist_sign = -sign(dist,sig)
! ----- Sign of colinear product VECT_PM . NORMAL(master)
        if (elem_dime .eq. 3) then
            tevapr = vect_pm(1)*mast_norm(1)+&
                     vect_pm(2)*mast_norm(2)+&
                     vect_pm(3)*mast_norm(3)
        elseif (elem_dime .eq. 2) then
            tevapr = vect_pm(1)*mast_norm(1)+&
                     vect_pm(2)*mast_norm(2)
        else
            ASSERT(ASTER_FALSE)
        end if
        if (debug) then
            write(*,*) "... Node: ",i_node,' - Coord: ', noma_coor
            write(*,*) " => Distance: ",dist,' - Distance signée: ', dist_sign
            write(*,*) " => VECT_PM . NORMAL: ", tevapr
        endif
! ----- No change of sign => no intersection
        if (dist_sign .lt. 0.d0-proj_tole) then
            if (tevapr .gt. 0.d0-proj_tole) then
                l_inter = ASTER_FALSE
                exit
            end if
        elseif (dist_sign .gt. 0.d0+proj_tole) then
            if (tevapr .lt. 0.d0+proj_tole) then
                l_inter = ASTER_FALSE
                exit
            end if
        end if     
    end do
!
end subroutine

