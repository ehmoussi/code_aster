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
subroutine lcgeog(elem_dime     , i_reso_geom   ,&
                  nb_lagr       , indi_lagc     ,&
                  nb_node_slav  , nb_node_mast  ,&
                  elem_mast_init, elem_slav_init,&
                  elem_mast_coor, elem_slav_coor)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/jevech.h"
#include "asterfort/mmreac.h"
#include "Contact_type.h"
!
integer, intent(in) :: elem_dime, i_reso_geom
integer, intent(in) :: nb_lagr, indi_lagc(10)
integer, intent(in) :: nb_node_slav, nb_node_mast
real(kind=8), intent(in) :: elem_slav_init(nb_node_slav, elem_dime)
real(kind=8), intent(in) :: elem_mast_init(nb_node_mast, elem_dime)
real(kind=8), intent(inout) :: elem_slav_coor(nb_node_slav, elem_dime)
real(kind=8), intent(inout) :: elem_mast_coor(nb_node_mast, elem_dime)
!
! --------------------------------------------------------------------------------------------------
!
! Contact (LAC) - Elementary computations
!
! Get geometry
!
! --------------------------------------------------------------------------------------------------
!
! In  elem_dime        : dimension of elements
! In  i_reso_geom      : algorithm for geometry
! In  nb_lagr          : total number of Lagrangian dof on contact element
! In  indi_lagc        : PREVIOUS node where Lagrangian dof is present (1) or not (0)
! In  nb_node_slav     : number of nodes of for slave side from contact element
! In  nb_node_mast     : number of nodes of for master side from contact element
! In  elem_slav_init   : initial coordinates from slave side of contact element
! In  elem_mast_init   : initial coordinates from master side of contact element
! IO  elem_slav_coor   : updated coordinates from slave side of contact element
! IO  elem_mast_coor   : updated coordinates from master side of contact element
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: ppe
    integer :: jv_disp, jv_disp_incr
!
! --------------------------------------------------------------------------------------------------
!
    call jevech('PDEPL_P', 'L', jv_disp_incr)
    call jevech('PDEPL_M', 'L', jv_disp)
!
! - Coefficient to update gap
!
    ppe = 0.d0
    if (i_reso_geom .eq. ALGO_NEWT) then
        ppe = 1.d0
    endif
!
! - Get updated coordinates
!
    call mmreac(elem_dime     , nb_node_slav  , nb_node_mast,&
                jv_disp       , jv_disp_incr  , ppe,&
                elem_slav_init, elem_mast_init,&
                elem_slav_coor, elem_mast_coor,&
                nb_lagr_   = nb_lagr,&
                indi_lagc_ = indi_lagc)
!
end subroutine  
