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
subroutine lcvect(elem_dime   , l_axis   , l_upda_jaco   , l_norm_smooth ,&
                  nb_lagr     , indi_lagc, lagrc         ,&
                  nb_node_slav, elem_slav_code, elem_slav_init, elga_fami_slav, elem_slav_coor,&
                  nb_node_mast, elem_mast_code, elem_mast_init, elga_fami_mast, elem_mast_coor,&
                  nb_poin_inte, poin_inte_sl, poin_inte_ma,&
                  vect, gapi, nmcp)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/lcnorm_line.h"
#include "asterfort/lcptga.h"
#include "asterfort/lcsees.h"
#include "asterfort/lcsegp.h"
#include "asterfort/lcsema.h"
#include "asterfort/lctppe.h"
#include "asterfort/lctrco.h"
#include "asterfort/lctria.h"
!
integer, intent(in) :: elem_dime
aster_logical, intent(in) :: l_axis
aster_logical, intent(in) :: l_upda_jaco
aster_logical, intent(in) :: l_norm_smooth
integer, intent(in) :: nb_lagr
integer, intent(in) :: indi_lagc(10)
real(kind=8), intent(in) :: lagrc, gapi
character(len=8), intent(in) :: elem_slav_code
character(len=8), intent(in) :: elem_mast_code
integer, intent(in) :: nb_node_slav
integer, intent(in) :: nb_node_mast
integer, intent(in) :: nmcp
integer, intent(in) :: nb_poin_inte
real(kind=8), intent(in):: poin_inte_sl(16)
real(kind=8), intent(in):: poin_inte_ma(16)
real(kind=8), intent(in):: elem_mast_init(27)
real(kind=8), intent(in):: elem_slav_init(27)
real(kind=8), intent(in) :: elem_mast_coor(27)
real(kind=8), intent(in):: elem_slav_coor(27)
character(len=8), intent(in) :: elga_fami_slav
character(len=8), intent(in) :: elga_fami_mast
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
! In  elga_fami_slav   : name of integration scheme for slave side from contact element
! In  nb_node_mast     : number of nodes of for master side from contact element
! In  elem_mast_code   : code element for master side from contact element
! In  elem_mast_init   : initial coordinates from master side of contact element
! In  elga_fami_mast   : name of integration scheme for master side from contact element
! IO  vect             : vector
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_node, i_dime, i_tria, i_gauss
    real(kind=8) :: norm_g(3)
    integer :: nb_tria
    integer :: tria_node(6,3)
    real(kind=8) :: tria_coot(2,3), tria_coor(16)
    integer :: nb_gauss
    real(kind=8) :: gauss_weight(12), gauss_coor(2,12), poidpg, gauss_coot(2), jacobian
    real(kind=8) :: shape_func(9), shape_dfunc(2, 9)
!
! --------------------------------------------------------------------------------------------------
!
! -----------Triangulation of convex polygon defined by intersection points
    if (elem_dime .eq. 3) then
        call lctria(nb_poin_inte, nb_tria, tria_node)
    elseif (elem_dime .eq. 2) then
        nb_tria = 1
    else
        ASSERT(ASTER_FALSE)
    end if
! -----------Loop on triangles
    do i_tria = 1, nb_tria
! -------------- Coordinates of current triangle
        tria_coor(:)=0.d0
        if (elem_dime .eq. 3) then
            call lctrco(i_tria, tria_node, poin_inte_sl, tria_coor)
        elseif (elem_dime .eq. 2) then
            tria_coor(1:16) = poin_inte_sl(1:16)
        endif
! -------------- Change shape of vector
        tria_coot(1:2,1:3) = 0.d0
        if (elem_dime .eq. 3) then
            do i_node = 1,3
                do i_dime = 1,(elem_dime-1)
                    tria_coot(i_dime, i_node) = &
                        tria_coor((i_node-1)*(elem_dime-1)+i_dime)
                end do
            end do
        else
            tria_coot(1,1) = tria_coor(1)
            tria_coot(2,1) = 0.d0
            tria_coot(1,2) = tria_coor(2)
            tria_coot(2,2) = 0.d0
        end if
! -------------- Get integration points for slave element
        call lcptga(elem_dime, tria_coot , elga_fami_slav,&
                    nb_gauss , gauss_coor, gauss_weight)
! -------------- Loop on integration points in slave element
        do i_gauss = 1, nb_gauss
! ------------------ Get current integration point
            gauss_coot(1:2) = 0.d0
            do i_dime = 1, elem_dime-1
                gauss_coot(i_dime) = gauss_coor(i_dime, i_gauss)
            end do
            poidpg = gauss_weight(i_gauss)
! ------------------ Compute geometric quantities for contact (slave side)
            call lctppe('Slave'       , l_axis        , l_upda_jaco,&
                        nb_node_slav  , elem_dime     , elem_slav_code  ,&
                        elem_slav_init, elem_slav_coor, &
                        gauss_coot    , shape_func    , shape_dfunc,&
                        jacobian      , norm_g)
! ------------------ Compute contact vector - geometric (slave side)
            call lcsees(elem_dime    , nb_node_slav, nb_lagr ,&
                        l_norm_smooth, norm_g   , norm_g  ,&
                        indi_lagc    , lagrc       ,&
                        poidpg       , shape_func  , jacobian,&
                        vect)
            call lcsegp(elem_dime   , nb_lagr, indi_lagc,&
                        nb_node_slav, nmcp   , gapi     , vect)
        end do
! -------------- Coordinates of current triangle
        tria_coor(:)=0.d0
        if (elem_dime .eq. 3) then
            call lctrco(i_tria, tria_node, poin_inte_ma, tria_coor)
        elseif (elem_dime .eq. 2) then
            tria_coor(1:16) = poin_inte_ma(1:16)
        endif
! -------------- Change shape of vector
        tria_coot(1:2,1:3) = 0.d0
        if (elem_dime .eq. 3) then
            do i_node = 1,3
                do i_dime = 1,(elem_dime-1)
                    tria_coot(i_dime, i_node) = &
                        tria_coor((i_node-1)*(elem_dime-1)+i_dime)
                end do
            end do
        else
            tria_coot(1,1) = tria_coor(1)
            tria_coot(2,1) = 0.d0
            tria_coot(1,2) = tria_coor(2)
            tria_coot(2,2) = 0.d0
        end if
! -------------- Get integration points for master element
        call lcptga(elem_dime, tria_coot , elga_fami_mast,&
                    nb_gauss , gauss_coor, gauss_weight)
! -------------- Loop on integration points in master element
        do i_gauss = 1, nb_gauss
! ------------------ Get current integration point
            gauss_coot(1:2) = 0.d0
            do i_dime = 1, elem_dime-1
                gauss_coot(i_dime) = gauss_coor(i_dime,i_gauss)
            end do
            poidpg = gauss_weight(i_gauss)
! ------------------ Compute geometric quantities for contact (master side)
            call lctppe('Master'      , l_axis        , l_upda_jaco,&
                        nb_node_mast  , elem_dime     , elem_mast_code  ,&
                        elem_mast_init, elem_mast_coor, &
                        gauss_coot    , shape_func    , shape_dfunc,&
                        jacobian      , norm_g)
! ------------------ Compute contact vector (master side)
            call lcsema(elem_dime, nb_node_mast, nb_node_slav, nb_lagr,&
                        l_norm_smooth, norm_g      , norm_g      ,&
                        lagrc       ,&
                        poidpg   , shape_func  , jacobian,&
                        vect)
        end do
    end do
!
end subroutine
