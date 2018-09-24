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
subroutine lcgeog(algo_reso_geom, l_previous    ,&
                  elem_dime     , nb_lagr       , indi_lagc,&
                  nb_node_slav  , nb_node_mast  ,&
                  elem_mast_init, elem_slav_init,&
                  elem_mast_coor, elem_slav_coor,&
                  norm_smooth)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/jevech.h"
#include "asterfort/lcreac.h"
!
integer, intent(in) :: algo_reso_geom
aster_logical, intent(in) :: l_previous
integer, intent(in) :: elem_dime
integer, intent(in) :: nb_lagr
integer, intent(in) :: indi_lagc(10)
integer, intent(in) :: nb_node_slav
integer, intent(in) :: nb_node_mast
real(kind=8), intent(in) :: elem_slav_init(elem_dime, nb_node_slav)
real(kind=8), intent(in) :: elem_mast_init(elem_dime, nb_node_mast)
real(kind=8), intent(inout) :: elem_slav_coor(elem_dime, nb_node_slav)
real(kind=8), intent(inout) :: elem_mast_coor(elem_dime, nb_node_mast)
integer, intent(out) :: norm_smooth
!
! --------------------------------------------------------------------------------------------------
!
! Contact (LAC) - Elementary computations
!
! Get geometry
!
! --------------------------------------------------------------------------------------------------
!
! In  algo_reso_geom   : algorithm for geometry loop
!                         0 - fixed point
!                         1 - Newton
! In  l_previous       : .true. to get previous state
! In  elem_dime        : dimension of elements
! In  nb_lagr          : total number of Lagrangian dof on contact element
! In  indi_lagc        : PREVIOUS node where Lagrangian dof is present (1) or not (0)
! In  nb_node_slav     : number of nodes of for slave side from contact element
! In  nb_node_mast     : number of nodes of for master side from contact element
! In  elem_slav_init   : initial coordinates from slave side of contact element
! In  elem_mast_init   : initial coordinates from master side of contact element
! IO  elem_slav_coor   : updated coordinates from slave side of contact element
! IO  elem_mast_coor   : updated coordinates from master side of contact element
! Out norm_smooth      : indicator for normals smoothing
!
! --------------------------------------------------------------------------------------------------
!
    integer :: jpcf, jv_disp, jv_disp_incr, jv_ddisp
    real(kind=8):: coef_upda_geom
!
! --------------------------------------------------------------------------------------------------
!
    call jevech('PCONFR', 'L', jpcf)
    call jevech('PDEPL_P', 'L', jv_disp_incr)
    call jevech('PDEPL_M', 'L', jv_disp)
!
! - Smooth normals ?
!
    norm_smooth = nint(zr(jpcf-1+1))
!
! - Coefficient to update geometry
!
    if (algo_reso_geom .eq. 1) then
        coef_upda_geom = 1.d0
    else
        coef_upda_geom = 0.d0
    endif            
!
! - Get updated coordinates
!
    if (l_previous) then 
        call jevech('PDDEPLA', 'L', jv_ddisp)
        call lcreac(nb_lagr       , indi_lagc     , elem_dime, coef_upda_geom,&
                    nb_node_slav  , nb_node_mast  ,&
                    jv_disp       , jv_disp_incr  ,&
                    elem_slav_init, elem_mast_init,&
                    elem_slav_coor, elem_mast_coor,&
                    jv_ddisp)
                    
    else 
        call lcreac(nb_lagr       , indi_lagc     , elem_dime, coef_upda_geom,&
                    nb_node_slav  , nb_node_mast  ,&
                    jv_disp       , jv_disp_incr  ,&
                    elem_slav_init, elem_mast_init,&
                    elem_slav_coor, elem_mast_coor)
    end if
!
end subroutine  
