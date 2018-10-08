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
subroutine lcgeominit(elem_dime     ,&
                      nb_node_slav  , nb_node_mast  ,&
                      elem_mast_init, elem_slav_init)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/jevech.h"
!
integer, intent(in) :: elem_dime
integer, intent(in) :: nb_node_slav,  nb_node_mast
real(kind=8), intent(out) :: elem_slav_init(elem_dime, nb_node_slav)
real(kind=8), intent(out) :: elem_mast_init(elem_dime, nb_node_mast)
!
! --------------------------------------------------------------------------------------------------
!
! Contact (LAC) - Elementary computations
!
! Get initial geometry
!
! --------------------------------------------------------------------------------------------------
!
! In  elem_dime        : dimension of elements
! In  nb_node_slav     : number of nodes of for slave side from contact element
! In  nb_node_mast     : number of nodes of for master side from contact element
! Out elem_slav_init   : initial coordinates from slave side of contact element
! Out elem_mast_init   : initial coordinates from master side of contact element
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_node_slav, i_node_mast, i_dime
    integer :: jv_geom
!
! --------------------------------------------------------------------------------------------------
!
    call jevech('PGEOMER', 'L', jv_geom)
!
! - Slave nodes
!
    do i_node_slav = 1, nb_node_slav
        do i_dime = 1, elem_dime          
            elem_slav_init(i_dime, i_node_slav) =&
                zr(jv_geom+(i_node_slav-1)*elem_dime+i_dime-1) 
        end do
    end do
!
! - Master nodes
!
    do i_node_mast = 1, nb_node_mast
        do i_dime = 1, elem_dime
            elem_mast_init(i_dime, i_node_mast) = &
                zr(jv_geom+nb_node_slav*elem_dime+(i_node_mast-1)*elem_dime+i_dime- 1)
        end do
    end do
!
end subroutine  
