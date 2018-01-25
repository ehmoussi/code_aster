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
subroutine apinte_prsl(proj_tole       , elem_dime     , &
                       elem_mast_nbnode, elem_mast_coor, &
                       elem_slav_nbnode, elem_slav_coor, elem_slav_code,&
                       proj_coor       )
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/mmnewt.h"
!
real(kind=8), intent(in) :: proj_tole
integer, intent(in) :: elem_dime
integer, intent(in) :: elem_mast_nbnode
real(kind=8), intent(in) :: elem_mast_coor(3,9)
integer, intent(in) :: elem_slav_nbnode
real(kind=8), intent(in) :: elem_slav_coor(3,9)
character(len=8), intent(in) :: elem_slav_code
real(kind=8), intent(out) :: proj_coor(elem_dime-1,4)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Pairing segment to segment
!
! Project master nodes in slave element parametric space
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
! Out proj_coor        : projection of master nodes on slave element
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: debug, l_reli
    integer :: i_node, i_dime
    integer :: niverr
    real(kind=8) :: noma_coor(3)
    real(kind=8) :: ksi1, ksi2, tau1(3), tau2(3)
!
! --------------------------------------------------------------------------------------------------
!
    debug  = ASTER_FALSE
    l_reli = ASTER_FALSE
    proj_coor(elem_dime-1,4) = 0.d0
    if (debug) then
        write(*,*) ".. Project master nodes in slave element parametric space"
    endif
!
    do i_node = 1, elem_mast_nbnode
! ----- Get coordinates of master nodes
        noma_coor(1:3) = 0.d0
        do i_dime = 1, elem_dime
            noma_coor(i_dime) = elem_mast_coor(i_dime, i_node)
        end do
! ----- Projection on slave element
        l_reli = ASTER_FALSE
        call mmnewt(elem_slav_code, elem_slav_nbnode, elem_dime,&
                    elem_slav_coor, noma_coor       , 75       ,&
                    proj_tole     , ksi1            , ksi2     ,&
                    tau1          , tau2            ,&
                    niverr        , l_reli)
! ----- Get parametric coordinates of projection
        if (niverr .eq. 0) then
            proj_coor(1, i_node) = ksi1
            if (elem_dime .eq. 3) then
                proj_coor(2, i_node) = ksi2
            end if
        else
! --------- Projection failed => try line search
            l_reli = ASTER_TRUE
            call mmnewt(elem_slav_code, elem_slav_nbnode, elem_dime,&
                        elem_slav_coor, noma_coor       , 75       ,&
                        proj_tole     , ksi1            , ksi2     ,&
                        tau1          , tau2            ,&
                        niverr        , l_reli)
            if (niverr .eq. 0) then
                proj_coor(1, i_node) = ksi1
                if (elem_dime .eq. 3) then
                    proj_coor(2, i_node) = ksi2
                end if
            else
                write(*,*) "mmnewt failed"
                ASSERT(ASTER_FALSE)
            endif
        endif    
    end do
!
end subroutine

