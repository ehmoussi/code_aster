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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine mmreac(elem_dime     , nb_node_slav  , nb_node_mast,&
                  jv_disp       , jv_disp_incr  , ppe,&
                  elem_slav_init, elem_mast_init,&
                  elem_slav_coor, elem_mast_coor,&
                  nbdm_         , nb_lagr_      , indi_lagc_,&
                  ddepmam_)
!
implicit none
!
#include "jeveux.h"
!
integer, intent(in) :: elem_dime, nb_node_slav, nb_node_mast
integer, intent(in) :: jv_disp, jv_disp_incr
real(kind=8), intent(in) :: ppe
real(kind=8), intent(in) :: elem_slav_init(nb_node_slav, elem_dime)
real(kind=8), intent(in) :: elem_mast_init(nb_node_mast, elem_dime)
real(kind=8), intent(out) :: elem_slav_coor(nb_node_slav, elem_dime)
real(kind=8), intent(out) :: elem_mast_coor(nb_node_mast, elem_dime)
integer, optional, intent(in) :: nbdm_, nb_lagr_, indi_lagc_(10)
real(kind=8), optional, intent(out) :: ddepmam_(9, 3)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Update geometry
!
! --------------------------------------------------------------------------------------------------
!
! In  elem_dime        : dimension of problem (2 or 3)
! In  nb_node_slav     : number of slave nodes
! In  nb_node_mast     : number of master nodes
! In  jv_disp          : address for displacement at beginning of time step
! In  jv_disp_incr     : address for increment of displacement from beginning of time step
! In  ppe              : coefficient to update geometry
!                         PPE = 0 --> POINT_FIXE
!                         PPE = 1 --> NEWTON_GENE (FULL)
! In  elem_slav_init   : initial coordinates from slave side of contact element
! In  elem_mast_init   : initial coordinates from master side of contact element
! Out elem_slav_coor   : updated coordinates from slave side of contact element
! Out elem_mast_coor   : updated coordinates from master side of contact element
! In  nbdm             : number of components by node for all dof
! In  nb_lagr          : total number of Lagrangian dof on contact element
! In  indi_lagc        : PREVIOUS node where Lagrangian dof is present (1) or not (0)
! Out ddepmam          : increment of displacement from beginning of time step for master nodes
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_node_slav, i_node_mast, i_dime, deca
!
! --------------------------------------------------------------------------------------------------
!
    elem_slav_coor(:,:)  = 0.d0
    elem_mast_coor(:,:)  = 0.d0
    if (present(ddepmam_)) then
        ddepmam_(:,:) = 0.d0
    endif
    deca = 0
!
! - Slave nodes
!
    do i_node_slav = 1, nb_node_slav
        if (present(nbdm_)) then
            deca = (i_node_slav-1)*(nbdm_-elem_dime)
        else
            deca = deca+indi_lagc_(i_node_slav)
        endif
        do i_dime = 1, elem_dime
            elem_slav_coor(i_node_slav, i_dime) =&
                elem_slav_init(i_node_slav, i_dime)+&
                zr(jv_disp+(i_node_slav-1)*(elem_dime)+deca+i_dime-1)+ &
                ppe*zr(jv_disp_incr+(i_node_slav-1)*(elem_dime)+deca+i_dime-1)
        end do
    end do
!
! - Master nodes
!
    if (present(nbdm_)) then
        deca = nb_node_slav*nbdm_
    else
        deca = nb_node_slav*elem_dime+nb_lagr_
    endif
    do i_node_mast = 1, nb_node_mast
        do i_dime = 1, elem_dime
            elem_mast_coor(i_node_mast, i_dime) =&
                elem_mast_init(i_node_mast, i_dime)+&
                zr(jv_disp+(i_node_mast-1)*elem_dime+deca+i_dime-1)+&
                ppe*zr(jv_disp_incr+(i_node_mast-1)*elem_dime+deca+i_dime-1)
            if (present(ddepmam_)) then
                ddepmam_(i_node_mast, i_dime) =&
                    zr(jv_disp_incr+(i_node_mast-1)*elem_dime+deca+i_dime-1)
            endif
        end do
    end do
!
end subroutine
