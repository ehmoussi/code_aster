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
subroutine lcpjit(proj_tole       , elem_dime     , &
                  elem_mast_nbnode, elem_mast_coor, elem_mast_code,&
                  elem_slav_nbnode, elem_slav_coor, elem_slav_code,&
                  poin_inte       , inte_weight   , nb_poin_inte)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/lcodrm.h"
#include "asterfort/insema.h"
#include "asterfort/ptinma.h"
#include "asterfort/mmnewt.h"
#include "asterfort/apelem_getvertex.h"
#include "asterfort/apelem_inside.h"
#include "asterfort/apinte_weight.h"
!
real(kind=8), intent(in) :: proj_tole
integer, intent(in) :: elem_dime
integer, intent(in) :: elem_mast_nbnode
real(kind=8), intent(in) :: elem_mast_coor(elem_dime,elem_mast_nbnode)
character(len=8), intent(in) :: elem_mast_code
integer, intent(in) :: elem_slav_nbnode
real(kind=8), intent(in) :: elem_slav_coor(elem_dime,elem_slav_nbnode)
character(len=8), intent(in) :: elem_slav_code
real(kind=8), intent(out) :: poin_inte(elem_dime-1,16)
real(kind=8), intent(out) :: inte_weight
integer, intent(out) :: nb_poin_inte
!
! --------------------------------------------------------------------------------------------------
!
! Contact (LAC) - Elementary computations
!
! Projection/intersection of elements in slave parametric space
!
! --------------------------------------------------------------------------------------------------
!
! In  proj_tole        : tolerance for projection
! In  elem_dime        : dimension of elements
! In  elem_mast_nbnode : number of nodes of master element
! In  elem_mast_coor   : coordinates of master element
! In  elem_mast_code   : code of master element
! In  elem_slav_nbnode : number of nodes for slave element
! In  elem_slav_coor   : coordinates of slave element
! In  elem_slav_code   : code of slave element
! Out poin_inte        : list (sorted) of intersection points
! Out inte_weight      : total weight of intersection
! Out nb_poin_inte     : number of intersection points
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: debug, l_reli
    real(kind=8) :: node_line_coop(elem_dime-1,4)
    real(kind=8) :: proj_coop(elem_dime-1,4)
    real(kind=8) :: ksi1, ksi2, tau1(3), tau2(3)
    real(kind=8) :: noma_coor(3), xpt, ypt
    real(kind=8) :: xp1, yp1, xp2, yp2
    integer :: niverr, test, list_next(16), nb_node_line
    integer :: i_node, i_dime
    character(len=8) :: elem_line_code
    real(kind=8) :: elsl_coor(3,9)
!
! --------------------------------------------------------------------------------------------------
!
    nb_poin_inte       = 0
    inte_weight        = 0.d0
    poin_inte(:,:)     = 0.d0
    debug              = ASTER_FALSE
    l_reli             = ASTER_FALSE
    node_line_coop(elem_dime-1,4) = 0.d0
    elsl_coor(1:3,1:9) = 0.d0
    if (debug) then
        write(*,*) ". Projection/intersection"
    endif
!
! - Get coordinates of slave element
!
    do i_node = 1,elem_slav_nbnode
        do i_dime = 1,elem_dime
            elsl_coor(i_dime,i_node) = elem_slav_coor(i_dime,i_node)
        enddo
    enddo
!
! - Project master nodes in slave element parametric space
!
    if (debug) then
        write(*,*) ".. Project master nodes in slave element parametric space"
    endif 
    do i_node = 1, elem_mast_nbnode
! ----- Get coordinates of master nodes
        noma_coor(1:3) = 0.d0
        do i_dime = 1, elem_dime
            noma_coor(i_dime) = elem_mast_coor(i_dime, i_node)
        end do
! ----- Projection on slave element
        l_reli = ASTER_FALSE
        call mmnewt(elem_slav_code, elem_slav_nbnode, elem_dime,&
                    elsl_coor     , noma_coor       , 75       ,&
                    proj_tole     , ksi1            , ksi2     ,&
                    tau1          , tau2            ,&
                    niverr        , l_reli)
! ----- Get parametric coordinates of projection
        if (niverr .eq. 0) then
            proj_coop(1, i_node) = ksi1
            if (elem_dime .eq. 3) then
                proj_coop(2, i_node) = ksi2
            end if
        else
! --------- Projection failed => try line search
            l_reli = ASTER_TRUE
            call mmnewt(elem_slav_code, elem_slav_nbnode, elem_dime,&
                        elsl_coor     , noma_coor       , 75       ,&
                        proj_tole     , ksi1            , ksi2     ,&
                        tau1          , tau2            ,&
                        niverr        , l_reli)
            if (niverr .eq. 0) then
                proj_coop(1, i_node) = ksi1
                if (elem_dime .eq. 3) then
                    proj_coop(2, i_node) = ksi2
                end if
            else
                write(*,*) "mmnewt failed"
                ASSERT(ASTER_FALSE)
            endif
        endif
    end do
!
! - Get parametric coordinates of slave nodes (linear)
!
    call apelem_getvertex(elem_dime     , elem_slav_code,&
                          node_line_coop, nb_node_line  , elem_line_code)
!
! - Save projection of master nodes on slave element in list of intersection points
!
    call apelem_inside(proj_tole       , elem_dime, elem_line_code,&
                       elem_mast_nbnode, proj_coop,&
                       nb_poin_inte    , poin_inte)
!
! - Add slave nodes if they are inside master element
!
    do i_node = 1, nb_node_line
! ----- Current coordinates of slave node
        xpt = node_line_coop(1,i_node)
        ypt = 0.d0
        if (elem_dime .eq. 3) then
            ypt = node_line_coop(2,i_node)
        endif
! ----- Test if point is inside element
        call ptinma(elem_mast_nbnode, elem_dime, elem_mast_code, proj_coop, proj_tole,&
                    xpt             , ypt      , test)
        if (test .eq. 1) then    
            nb_poin_inte              = nb_poin_inte+1
            poin_inte(1,nb_poin_inte) = xpt
            if (elem_dime .eq. 3) then
                poin_inte(2,nb_poin_inte) = ypt
            end if
        endif
    end do
!
! - Set index of next nodes
!
    do i_node = 2, elem_mast_nbnode
        list_next(i_node-1) = i_node
    end do
    list_next(elem_mast_nbnode) = 1
!
! - Intersection of edges
!
    if (elem_dime .eq. 3) then
        do i_node = 1, elem_mast_nbnode
!
! --------- Segment from edge of master element
!
            xp1 = proj_coop(1,i_node)
            yp1 = proj_coop(2,i_node)
            xp2 = proj_coop(1,list_next(i_node))
            yp2 = proj_coop(2,list_next(i_node))
!
! --------- Compute intersection between edge of master and slave element
!
            call insema(nb_node_line, elem_dime, node_line_coop, proj_tole,&
                        xp1         , yp1      , xp2           , yp2      ,&
                        nb_poin_inte, poin_inte)
        end do
        ASSERT(nb_poin_inte .le. 16)
    end if
!
! - Sort list of intersection points
!
    if ((nb_poin_inte .gt. 2 .and. elem_dime .eq. 3) .or.&
        (nb_poin_inte .ge. 2 .and. elem_dime .eq. 2)) then
        call lcodrm(elem_dime, proj_tole, nb_poin_inte, poin_inte)
    endif
!
! - Compute weight of intersection
!
    call apinte_weight(elem_dime  , nb_poin_inte, poin_inte,&
                       inte_weight)
!
end subroutine
