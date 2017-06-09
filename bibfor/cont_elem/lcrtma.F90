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

subroutine lcrtma(elem_dime       , proj_tole,&
                  tria_coor       , &
                  elin_slav_nbnode, elin_slav_coor, elin_slav_code,&
                  elem_mast_nbnode, elem_mast_coor, elem_mast_code,&
                  tria_coot)
!
implicit none
!
#include "asterfort/mmnewd.h"
#include "asterfort/reerel.h"
#include "asterfort/mmdonf.h"
#include "asterfort/mmtang.h"
#include "asterfort/mmnorm.h"
#include "asterfort/assert.h"
!
!
    integer, intent(in) :: elem_dime
    real(kind=8), intent(in) :: proj_tole
    real(kind=8), intent(in) :: tria_coor(elem_dime-1,3)
    integer, intent(in) :: elin_slav_nbnode
    real(kind=8), intent(in) :: elin_slav_coor(elem_dime,elin_slav_nbnode)
    character(len=8), intent(in) :: elin_slav_code
    integer, intent(in) :: elem_mast_nbnode
    real(kind=8), intent(in) :: elem_mast_coor(elem_dime,elem_mast_nbnode)
    character(len=8), intent(in) :: elem_mast_code
    real(kind=8), intent(out) :: tria_coot(2,3)
!
! --------------------------------------------------------------------------------------------------
!
! Contact (LAC) - Elementary computations
!
! Projection of triangle in master parametric space
!
! --------------------------------------------------------------------------------------------------
!
! In  proj_tole        : tolerance for projection
! In  elem_dime        : dimension of elements
! In  tria_coor        : coordinates of triangle
! In  elin_slav_nbnode : number of nodes for each sub-element in slave element
! In  elin_slav_coor   : coordinates of sub-elements in slave element
! In  elin_slav_code   : code of all sub-elements in slave element
! In  elem_mast_nbnode : number of nodes for master element
! In  elem_mast_coor   : coordinates of master element
! In  elem_mast_code   : code of master element
! Out tria_coot        : coordinates of triangle in master parametric space
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_node,i_dime,niverr
    real(kind=8) :: tria_coor_real(3), tria_coor_para(2)
    real(kind=8) :: dff(2, 9)
    real(kind=8) :: tau1(3), tau2(3)
    real(kind=8) :: norm(3)
    real(kind=8) :: ksi1, ksi2
    real(kind=8) :: mast_coor(3,9), slav_coor(3,9)
!
! --------------------------------------------------------------------------------------------------
!
    tria_coot(1,1:3) = 0.d0
    tria_coot(2,1:3) = 0.d0
    tau1(1:3)        = 0.d0
    tau2(1:3)        = 0.d0
    norm(1:3)        = 0.d0
    mast_coor(1:3,1:9) = 0.d0
    slav_coor(1:3,1:9) = 0.d0
!
! - Get coordinates of elements
!
    do i_node = 1, elem_mast_nbnode
        do i_dime = 1, elem_dime
            mast_coor(i_dime, i_node) = elem_mast_coor(i_dime,i_node)
        enddo
    enddo
    do i_node=1,elin_slav_nbnode
        do i_dime=1,elem_dime
            slav_coor(i_dime, i_node) = elin_slav_coor(i_dime,i_node)
        enddo
    enddo
!
! - Loop on nodes of triangle
!
    do i_node = 1, elem_dime
        tau1(1:3) = 0.d0
        tau2(1:3) = 0.d0
        norm(1:3) = 0.d0
!
! ----- Coordinates of node
!
        tria_coor_para(1)=tria_coor(1, i_node)
        if (elem_dime .eq. 3) then
            tria_coor_para(2) = tria_coor(2,i_node)
        else
            tria_coor_para(2) = 0.d0
        end if
        tria_coor_real(1:3)=0.d0
!
! ----- Project in real space
!
        call reerel(elin_slav_code, elin_slav_nbnode, elem_dime, elin_slav_coor,&
                    tria_coor_para, tria_coor_real)
!
! ----- Compute normal
!
        call mmdonf(elem_dime, elin_slav_nbnode, elin_slav_code,&
                    tria_coor_para(1), tria_coor_para(2),&
                    dff)
        call mmtang(elem_dime, elin_slav_nbnode, slav_coor, dff, tau1,&
                    tau2)
        call mmnorm(elem_dime, tau1, tau2, norm)
!
! ----- Project in parametric space
!
        call mmnewd(elem_mast_code, elem_mast_nbnode, elem_dime,&
                    mast_coor     , tria_coor_real  ,&
                    100           , proj_tole       , norm     ,&
                    ksi1, ksi2, tau1, tau2, niverr)
        if (niverr.eq.1) then
            write(*,*)"mmnewd failed"
            ASSERT(.false.)
        end if
!
        tria_coot(1,i_node) = ksi1
        if ((elem_dime-1) .eq.2) then
            tria_coot(2,i_node) = ksi2
        end if
    end do
!
end subroutine
