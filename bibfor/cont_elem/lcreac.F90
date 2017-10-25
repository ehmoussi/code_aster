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

subroutine lcreac(nb_lagr       , indi_lagc      , elem_dime   , coef_upda_geom,&
                  nb_node_slav  , nb_node_mast   ,&
                  jv_geom       , jv_disp        , jv_disp_incr,&
                  elem_slav_coor, elem_mast_coor , jv_ddisp)
!
implicit none
!
#include "jeveux.h"
!
!
    integer, intent(in) :: elem_dime
    integer, intent(in) :: nb_lagr
    integer, intent(in) :: indi_lagc(10)
    integer, intent(in) :: nb_node_slav
    integer, intent(in) :: nb_node_mast
    real(kind=8), intent(in) :: coef_upda_geom     
    integer, intent(in) :: jv_geom
    integer, intent(in) :: jv_disp
    integer, intent(in) :: jv_disp_incr
    integer, intent(in), optional :: jv_ddisp
    real(kind=8), intent(inout) :: elem_slav_coor(elem_dime, nb_node_slav)
    real(kind=8), intent(inout) :: elem_mast_coor(elem_dime, nb_node_mast)
!
! --------------------------------------------------------------------------------------------------
!
! Contact (LAC) - Elementary computations
!
! Get updated coordinates
!
! --------------------------------------------------------------------------------------------------
!
! In  elem_dime        : dimension of elements
! In  nb_lagr          : total number of Lagrangian dof on contact element
! In  indi_lagc        : PREVIOUS node where Lagrangian dof is present (1) or not (0)
! In  coef_upda_geom   : coefficient to update geometry
! In  nb_node_slav     : number of nodes of for slave side from contact element
! In  nb_node_mast     : number of nodes of for master side from contact element
! In  jv_geom          : JEVEUX adress for initial geometry (from mesh)
! In  jv_disp          : JEVEUX adress for displacement at beginning of time step
! In  jv_disp_incr     : JEVEUX adress for increment of displacement from beginning of time step
! IO  elem_slav_coor   : updated coordinates from slave side of contact element
! IO  elem_mast_coor   : updated coordinates from master side of contact element
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_node_slav, i_node_mast, i_dime, deca
!
! --------------------------------------------------------------------------------------------------
!
    deca=0
!
! - Slave nodes
!
    do i_node_slav = 1, nb_node_slav
        deca = deca+indi_lagc(i_node_slav)
        do i_dime = 1, elem_dime          
            elem_slav_coor(i_dime, i_node_slav) =&
                zr(jv_geom+(i_node_slav-1)*elem_dime+i_dime-1) +&
                zr(jv_disp+(i_node_slav-1)*(elem_dime)+deca+i_dime-1)+ &
                coef_upda_geom*&
                zr(jv_disp_incr+(i_node_slav-1)*(elem_dime)+deca+i_dime-1) 
                
                if(present(jv_ddisp)) then 
                   elem_slav_coor(i_dime, i_node_slav) =&
                      elem_slav_coor(i_dime, i_node_slav)-&
                      zr(jv_ddisp+(i_node_slav-1)*(elem_dime)+deca+i_dime-1) 
                end if                  
        end do
    end do
!
! - Master nodes
!
    do i_node_mast = 1, nb_node_mast
        do i_dime = 1, elem_dime
            elem_mast_coor(i_dime, i_node_mast) = &
                zr(jv_geom+nb_node_slav*elem_dime+(i_node_mast-1)*elem_dime+i_dime- 1)+&
                zr(jv_disp+nb_node_slav*elem_dime+nb_lagr+(i_node_mast-1)*elem_dime+i_dime-1)+&
                coef_upda_geom*&
                zr(jv_disp_incr+nb_node_slav*elem_dime+nb_lagr+(i_node_mast-1)*elem_dime+i_dime-1)
                
                if(present(jv_ddisp)) then 
                    elem_mast_coor(i_dime, i_node_mast) = &
                        elem_mast_coor(i_dime, i_node_mast)-&
                 zr(jv_ddisp+nb_node_slav*elem_dime+nb_lagr+(i_node_mast-1)*elem_dime+i_dime-1)
                end if 
        end do
  end do
!
end subroutine
