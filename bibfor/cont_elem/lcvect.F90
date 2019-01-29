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
! aslint: disable=W1504
!
subroutine lcvect(elem_dime   , l_axis        , l_upda_jaco   , l_norm_smooth ,&
                  nb_lagr     , indi_lagc     , lagrc         , elga_fami     ,&
                  nb_node_slav, elem_slav_code, elem_slav_init, elem_slav_coor,&
                  nb_node_mast, elem_mast_code, elem_mast_init, elem_mast_coor,&
                  nb_poin_inte, poin_inte_sl  , poin_inte_ma,&
                  vect, gapi, nmcp)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/lcptga.h"
#include "asterfort/lcsees.h"
#include "asterfort/lcsegp.h"
#include "asterfort/lcsema.h"
#include "asterfort/lcgeom_prep.h"
#include "asterfort/lctrco.h"
#include "asterfort/lctria.h"
!
integer, intent(in) :: elem_dime
aster_logical, intent(in) :: l_axis, l_upda_jaco, l_norm_smooth
integer, intent(in) :: nb_lagr, indi_lagc(10)
real(kind=8), intent(in) :: lagrc, gapi
character(len=8), intent(in) :: elem_slav_code, elem_mast_code
integer, intent(in) :: nb_node_slav, nb_node_mast
integer, intent(in) :: nmcp
integer, intent(in) :: nb_poin_inte
real(kind=8), intent(in) :: poin_inte_sl(16), poin_inte_ma(16)
real(kind=8), intent(in) :: elem_mast_init(nb_node_mast, elem_dime)
real(kind=8), intent(in) :: elem_slav_init(nb_node_slav, elem_dime)
real(kind=8), intent(in) :: elem_mast_coor(nb_node_mast, elem_dime)
real(kind=8), intent(in) :: elem_slav_coor(nb_node_slav, elem_dime)
character(len=8), intent(in) :: elga_fami
real(kind=8), intent(inout) :: vect(55)
!
! --------------------------------------------------------------------------------------------------
!
! Contact (LAC) - Elementary computations
!
! Compute vector if contact
!
! --------------------------------------------------------------------------------------------------
!
! In  elem_dime        : dimension of elements
! In  l_axis           : .true. for axisymmetric element
! In  l_upda_jaco      : .true. to use updated jacobian
! In  nb_lagr          : total number of Lagrangian dof on contact element
! In  indi_lagc        : PREVIOUS node where Lagrangian dof is present (1) or not (0)
! In  lagrc            : value of contact lagrangian
! In  l_norm_smooth    : indicator for normals smoothing
! In  nb_node_slav     : number of nodes of for slave side from contact element
! In  elem_slav_code   : code element for slave side from contact element
! In  elem_slav_init   : initial coordinates from slave side of contact element
! In  elga_fami        : name of integration scheme from contact element
! In  nb_node_mast     : number of nodes of for master side from contact element
! In  elem_mast_code   : code element for master side from contact element
! In  elem_mast_init   : initial coordinates from master side of contact element
! IO  vect             : vector
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_node, i_dime, i_tria, i_gauss
    integer :: nb_tria
    integer :: tria_node(6,3)
    real(kind=8) :: tria_coot_sl(2,3), tria_coor_sl(16)
    real(kind=8) :: tria_coot_ma(2,3), tria_coor_ma(16)
    integer :: nb_gauss
    real(kind=8) :: poidpg_sl, poidpg_ma, jacobian_ma, jacobian_sl
    real(kind=8) :: gauss_weight_sl(12), gauss_coor_sl(2,12), gauss_coot_sl(2)
    real(kind=8) :: gauss_weight_ma(12), gauss_coor_ma(2,12), gauss_coot_ma(2)
    real(kind=8) :: shape_func_sl(9), shape_func_ma(9)
    real(kind=8) :: dist_vect_sl(3), dist_vect_ma(3)
!
! --------------------------------------------------------------------------------------------------
!
! - Triangulation of convex polygon defined by intersection points
    if (elem_dime .eq. 3) then
        call lctria(nb_poin_inte, nb_tria, tria_node)
    elseif (elem_dime .eq. 2) then
        nb_tria = 1
    else
        ASSERT(ASTER_FALSE)
    end if
! - Loop on triangles
    do i_tria = 1, nb_tria
! ----- Coordinates of current triangle (slave)
        tria_coor_sl(:) = 0.d0
        if (elem_dime .eq. 3) then
            call lctrco(i_tria, tria_node, poin_inte_sl, tria_coor_sl)
        elseif (elem_dime .eq. 2) then
            tria_coor_sl(1:16) = poin_inte_sl(1:16)
        endif
! ----- Change shape of vector (slave)
        tria_coot_sl(1:2,1:3) = 0.d0
        if (elem_dime .eq. 3) then
            do i_node = 1,3
                do i_dime = 1,(elem_dime-1)
                    tria_coot_sl(i_dime, i_node) = &
                        tria_coor_sl((i_node-1)*(elem_dime-1)+i_dime)
                end do
            end do
        else
            tria_coot_sl(1,1) = tria_coor_sl(1)
            tria_coot_sl(2,1) = 0.d0
            tria_coot_sl(1,2) = tria_coor_sl(2)
            tria_coot_sl(2,2) = 0.d0
        end if
! ----- Coordinates of current triangle (master)
        tria_coor_ma(:) = 0.d0
        if (elem_dime .eq. 3) then
            call lctrco(i_tria, tria_node, poin_inte_ma, tria_coor_ma)
        elseif (elem_dime .eq. 2) then
            tria_coor_ma(1:16) = poin_inte_ma(1:16)
        endif
! ----- Change shape of vector (master)
        tria_coot_ma(1:2,1:3) = 0.d0
        if (elem_dime .eq. 3) then
            do i_node = 1,3
                do i_dime = 1,(elem_dime-1)
                    tria_coot_ma(i_dime, i_node) = &
                        tria_coor_ma((i_node-1)*(elem_dime-1)+i_dime)
                end do
            end do
        else
            tria_coot_ma(1,1) = tria_coor_ma(1)
            tria_coot_ma(2,1) = 0.d0
            tria_coot_ma(1,2) = tria_coor_ma(2)
            tria_coot_ma(2,2) = 0.d0
        end if
! ----- Get integration points for slave element
        call lcptga(elem_dime, tria_coot_sl , elga_fami      ,&
                    nb_gauss , gauss_coor_sl, gauss_weight_sl)
! ----- Get integration points for master element
        call lcptga(elem_dime, tria_coot_ma , elga_fami      ,&
                    nb_gauss , gauss_coor_ma, gauss_weight_ma)
! ----- Loop on integration points
        do i_gauss = 1, nb_gauss
! --------- Get current integration point (slave)
            gauss_coot_sl(1:2) = 0.d0
            do i_dime = 1, elem_dime-1
                gauss_coot_sl(i_dime) = gauss_coor_sl(i_dime, i_gauss)
            end do
            poidpg_sl = gauss_weight_sl(i_gauss)
! --------- Get current integration point (master)
            gauss_coot_ma(1:2) = 0.d0
            do i_dime = 1, elem_dime-1
                gauss_coot_ma(i_dime) = gauss_coor_ma(i_dime, i_gauss)
            end do
            poidpg_ma = gauss_weight_ma(i_gauss)
! --------- Compute geometric quantities for contact matrix (slave and master)
            call lcgeom_prep(elem_dime    , l_axis        , l_upda_jaco,&
                             nb_node_slav , elem_slav_code, elem_slav_init, elem_slav_coor,&
                             nb_node_mast , elem_mast_code, elem_mast_init, elem_mast_coor,&
                             gauss_coot_sl, gauss_coot_ma ,&
                             shape_func_sl, shape_func_ma ,&
                             jacobian_sl  , jacobian_ma   ,&
                             dist_vect_sl , dist_vect_ma)
! --------- Compute contact vector (slave side)
            call lcsees(elem_dime    , nb_node_slav, nb_lagr ,&
                        l_norm_smooth,&
                        indi_lagc    , lagrc        ,&
                        poidpg_sl    , shape_func_sl,&
                        jacobian_sl  , dist_vect_sl ,&
                        vect)
            call lcsegp(elem_dime   , nb_lagr, indi_lagc,&
                        nb_node_slav, nmcp   , gapi     , vect)
! --------- Compute contact vector (master side)
            call lcsema(elem_dime    , nb_node_mast , nb_node_slav, nb_lagr,&
                        l_norm_smooth,&
                        lagrc        ,&
                        poidpg_ma    , shape_func_ma,&
                        jacobian_ma  , dist_vect_ma ,&
                        vect)
        end do
    end do
!
end subroutine
