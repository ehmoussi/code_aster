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
subroutine lcmatr(elem_dime   ,&
                  l_axis      , l_upda_jaco   , l_norm_smooth ,&
                  nb_lagr     , indi_lagc     ,&
                  nb_node_slav, elem_slav_code, elem_slav_init, elga_fami_slav, elem_slav_coor,&
                  nb_node_mast, elem_mast_code, elem_mast_init, elga_fami_mast, elem_mast_coor,&
                  matr)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/apdcma.h"
#include "asterfort/lcnorm_line.h"
#include "asterfort/lcpjit.h"
#include "asterfort/lctria.h"
#include "asterfort/lctrco.h"
#include "asterfort/aprtpe.h"
#include "asterfort/lcptga.h"
#include "asterfort/lctppe.h"
#include "asterfort/lccoes.h"
#include "asterfort/lcrtma.h"
#include "asterfort/lccoma.h"
!
integer, intent(in) :: elem_dime
aster_logical, intent(in) :: l_axis, l_upda_jaco, l_norm_smooth
integer, intent(in) :: nb_lagr, indi_lagc(10)
character(len=8), intent(in) :: elem_slav_code, elem_mast_code
integer, intent(in) :: nb_node_slav, nb_node_mast
real(kind=8), intent(in):: elem_mast_init(27), elem_slav_init(27)
real(kind=8), intent(in) :: elem_mast_coor(27), elem_slav_coor(27)
character(len=8), intent(in) :: elga_fami_slav, elga_fami_mast
real(kind=8), intent(inout) :: matr(55, 55)
!
! --------------------------------------------------------------------------------------------------
!
! Contact (LAC) - Elementary computations
!
! Compute matrix if contact
!
! --------------------------------------------------------------------------------------------------
!
! In  elem_dime        : dimension of elements
! In  l_axis           : .true. for axisymmetric element
! In  l_upda_jaco      : .true. to use updated jacobian
! In  nb_lagr          : total number of Lagrangian dof on contact element
! In  indi_lagc        : PREVIOUS node where Lagrangian dof is present (1) or not (0)
! In  l_norm_smooth    : indicator for normals smoothing
! In  nb_node_slav     : number of nodes of for slave side from contact element
! In  elem_slav_code   : code element for slave side from contact element
! In  elem_slav_init   : initial coordinates from slave side of contact element
! In  elga_fami_slav   : name of integration scheme for slave side from contact element
! In  nb_node_mast     : number of nodes of for master side from contact element
! In  elem_mast_code   : code element for master side from contact element
! In  elem_mast_init   : initial coordinates from master side of contact element
! In  elga_fami_mast   : name of integration scheme for master side from contact element
! IO  matr             : matrix
!
! --------------------------------------------------------------------------------------------------
!
    integer :: elin_mast_nbsub, elin_mast_sub(2,3), elin_mast_nbnode(2)
    real(kind=8) :: elin_mast_coor(3, 9)
    character(len=8) :: elin_mast_code
    integer :: elin_slav_nbsub, elin_slav_sub(2,3), elin_slav_nbnode(2)
    real(kind=8) :: elin_slav_coor(3, 9)
    character(len=8) :: elin_slav_code
    integer :: i_elin_slav, i_elin_mast
    integer :: i_node, i_dime, i_tria, i_gauss
    real(kind=8) :: norm_line(3), norm_g(3), proj_tole
    integer :: nb_poin_inte, nb_tria
    real(kind=8) :: poin_inte(32)
    real(kind=8) :: inte_weight
    integer :: tria_node(6,3)
    real(kind=8) :: tria_coot(2,3), tria_coor(32), tria_coor_aux(32)
    integer :: nb_gauss
    real(kind=8) :: gauss_weight(12), gauss_coor(2,12), poidpg, gauss_coot(2), jacobian
    real(kind=8) :: shape_func(9), shape_dfunc(2, 9)
!
! --------------------------------------------------------------------------------------------------
!
    proj_tole = 1.d-9
!
! - Cut elements in linearized sub-elements
!
    call apdcma(elem_mast_code,&
                elin_mast_sub, elin_mast_nbnode, elin_mast_nbsub, elin_mast_code)
    call apdcma(elem_slav_code,&
                elin_slav_sub, elin_slav_nbnode, elin_slav_nbsub, elin_slav_code)
!
! - Loop on linearized slave sub-elements
!
    do i_elin_slav = 1, elin_slav_nbsub
! ----- Get coordinates for current linearized slave sub-element
        elin_slav_coor(: , :) = 0.d0
        do i_node = 1, elin_slav_nbnode(i_elin_slav)
            do i_dime = 1, elem_dime
                elin_slav_coor(i_dime, i_node) = &
                   elem_slav_coor((elin_slav_sub(i_elin_slav,i_node)-1)*elem_dime+i_dime)
            end do
        end do
! ----- Compute normal vector for current linearized slave sub-element
        call lcnorm_line(elin_slav_code, elin_slav_coor, norm_line)
! ----- Loop on linearized master sub-elements      
        do i_elin_mast = 1, elin_mast_nbsub
! --------- Get coordinates for current linearized master sub-element
            elin_mast_coor(:, :) = 0.d0
            do i_node = 1, elin_mast_nbnode(i_elin_mast)
                do i_dime = 1, elem_dime
                    elin_mast_coor(i_dime, i_node) = &
                        elem_mast_coor((elin_mast_sub(i_elin_mast,i_node)-1)*elem_dime+i_dime)
                end do
            end do
!---------- Projection/intersection
            call lcpjit(proj_tole                    , elem_dime     ,&
                        elin_mast_nbnode(i_elin_mast), elin_mast_coor, elin_mast_code,&
                        elin_slav_nbnode(i_elin_slav), elin_slav_coor, elin_slav_code,&
                        poin_inte                    , inte_weight   , nb_poin_inte)
            if (inte_weight .gt. proj_tole) then
! ------------- Triangulation of convex polygon defined by intersection points
                if (elem_dime .eq. 3) then
                    call lctria(nb_poin_inte, nb_tria, tria_node)
                elseif (elem_dime .eq. 2) then
                    nb_tria = 1
                else
                    ASSERT(ASTER_FALSE)
                end if
! ------------- Loop on triangles
                do i_tria = 1, nb_tria
! ----------------- Coordinates of current triangle
                    if (elem_dime .eq. 3) then
                        call lctrco(i_tria, tria_node, poin_inte, tria_coor)
                    elseif (elem_dime .eq. 2) then
                        tria_coor(1:32) = poin_inte(1:32)
                    endif
                    tria_coor_aux(1:32) = tria_coor(1:32)
! ----------------- Projection from parametric space of triangle in real space
                    if (elem_slav_code .ne. elin_slav_code ) then
                        call aprtpe(elem_dime, elem_slav_code, i_elin_slav,&
                                    3, tria_coor)
                    endif
! ----------------- Change shape of vector
                    tria_coot(1:2,1:3)=0.d0
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
! ----------------- Get integration points for slave element
                    call lcptga(elem_dime, tria_coot , elga_fami_slav,&
                                nb_gauss , gauss_coor, gauss_weight)
! ----------------- Loop on integration points in slave element
                    do i_gauss = 1, nb_gauss
! --------------------- Get current integration point
                        gauss_coot(1:2) = 0.d0
                        do i_dime = 1, elem_dime-1
                            gauss_coot(i_dime) = gauss_coor(i_dime, i_gauss)
                        end do
                        poidpg = gauss_weight(i_gauss)
! --------------------- Compute geometric quantities for contact (slave side)
                        call lctppe('Slave'       , l_axis        , l_upda_jaco   ,&
                                    nb_node_slav  , elem_dime     , elem_slav_code,&
                                    elem_slav_init, elem_slav_coor, &
                                    gauss_coot    , shape_func    , shape_dfunc   ,&
                                    jacobian      , norm_g)
! --------------------- Compute contact matrix (slave side)
                        call lccoes(elem_dime    , nb_node_slav, nb_lagr   ,&
                                    l_norm_smooth, norm_line   , norm_g    ,&
                                    indi_lagc    , poidpg      , shape_func, jacobian,&
                                    matr)
                    end do
! ----------------- Projection of triangle in master parametric space
                    call lcrtma(elem_dime       , proj_tole,&
                                tria_coor_aux   , &
                                elin_slav_nbnode(i_elin_slav), elin_slav_coor, elin_slav_code,&
                                nb_node_mast                 , elem_mast_coor, elem_mast_code,&
                                tria_coot)
! ----------------- Get integration points for master element
                    call lcptga(elem_dime, tria_coot , elga_fami_mast,&
                                nb_gauss , gauss_coor, gauss_weight)
! ----------------- Loop on integration points in master element
                    do i_gauss = 1, nb_gauss
! --------------------- Get current integration point
                        gauss_coot(1:2) = 0.d0
                        do i_dime = 1, elem_dime-1
                            gauss_coot(i_dime) = gauss_coor(i_dime,i_gauss)
                        end do
                        poidpg = gauss_weight(i_gauss)
! --------------------- Compute geometric quantities for contact (master side)
                        call lctppe('Master'      , l_axis        , l_upda_jaco,&
                                    nb_node_mast  , elem_dime     , elem_mast_code  ,&
                                    elem_mast_init, elem_mast_coor, &
                                    gauss_coot    , shape_func    , shape_dfunc,&
                                    jacobian      , norm_g)
! --------------------- Compute contact matrix (master side)
                        call lccoma(elem_dime    , nb_node_mast, nb_node_slav, nb_lagr ,&
                                    l_norm_smooth, norm_line   , norm_g      ,&
                                    indi_lagc    , poidpg      , shape_func  , jacobian,&
                                    matr)
                   end do
                end do
            endif
        end do
    end do
! 
end subroutine
