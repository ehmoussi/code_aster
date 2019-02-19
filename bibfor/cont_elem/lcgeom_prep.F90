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
!
subroutine lcgeom_prep(elem_dime    , l_axis        , l_upda_jaco,&
                       nb_node_slav , elem_slav_code, elem_slav_init, elem_slav_coor,&
                       nb_node_mast , elem_mast_code, elem_mast_init, elem_mast_coor,&
                       gauss_coot_sl, gauss_coot_ma ,&
                       shape_func_sl, shape_func_ma ,&
                       jacobian_sl  , jacobian_ma   ,&
                       dist_vect_sl , dist_vect_ma)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/lctppe.h"
!
integer, intent(in) :: elem_dime
aster_logical, intent(in) :: l_axis, l_upda_jaco
integer, intent(in) :: nb_node_slav, nb_node_mast
character(len=8), intent(in) :: elem_slav_code, elem_mast_code
real(kind=8), intent(in) :: elem_mast_init(nb_node_mast, elem_dime)
real(kind=8), intent(in) :: elem_slav_init(nb_node_slav, elem_dime)
real(kind=8), intent(in) :: elem_mast_coor(nb_node_mast, elem_dime)
real(kind=8), intent(in) :: elem_slav_coor(nb_node_slav, elem_dime)
real(kind=8), intent(in) :: gauss_coot_sl(2), gauss_coot_ma(2)
real(kind=8), intent(out) :: shape_func_sl(9), shape_func_ma(9)
real(kind=8), intent(out) :: jacobian_sl, jacobian_ma
real(kind=8), intent(out) :: dist_vect_sl(3), dist_vect_ma(3)
!
! --------------------------------------------------------------------------------------------------
!
! Contact (LAC) - Elementary computations
!
! Compute geometric quantities for contact matrix (slave and master)
!
! --------------------------------------------------------------------------------------------------
!
! In  elem_dime        : dimension of elements
! In  l_axis           : .true. for axisymmetric element
! In  l_upda_jaco      : .true. to use updated jacobian
! In  nb_node_slav     : number of nodes of for slave side from contact element
! In  elem_slav_code   : code element for slave side from contact element
! In  elem_slav_init   : initial coordinates from slave side of contact element
! In  nb_node_mast     : number of nodes of for master side from contact element
! In  elem_mast_code   : code element for master side from contact element
! In  elem_mast_init   : initial coordinates from master side of contact element
! Out shape_func_sl    : shape functions at integration point for slave
! Out jacobian_sl      : jacobian at integration point for slave
! Out shape_func_ma    : shape functions at integration point for master
! Out jacobian_ma      : jacobian at integration point for master
! Out dist_vect_sl     : distance vector between slave and master (slave side)
! Out dist_vect_ma     : distance vector between slave and master (master side)
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: norm_g_sl(3), norm_g_ma(3)
!
! --------------------------------------------------------------------------------------------------
!
! - Compute geometric quantities for contact (slave side)
!
    call lctppe('Slave'       , l_axis         , l_upda_jaco   ,&
                nb_node_slav  , elem_dime      , elem_slav_code,&
                elem_slav_init, elem_slav_coor , &
                gauss_coot_sl , shape_func_sl  , &
                jacobian_sl   , norm_g_sl)
    dist_vect_sl = norm_g_sl
!
! - Compute geometric quantities for contact (master side)
!
    call lctppe('Master'      , l_axis        , l_upda_jaco   ,&
                nb_node_mast  , elem_dime     , elem_mast_code,&
                elem_mast_init, elem_mast_coor, &
                gauss_coot_ma , shape_func_ma , &
                jacobian_ma   , norm_g_ma)
    dist_vect_ma = norm_g_ma
!
end subroutine
