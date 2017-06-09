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

subroutine cfmeno(sdcont_defi , nb_cont_surf, nb_cont_node0, v_list_node, v_poin_node,&
                  nb_cont_node)
!
implicit none
!
#include "asterfort/jeecra.h"
#include "asterfort/jeveuo.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=24), intent(in) :: sdcont_defi
    integer, intent(in) :: nb_cont_surf
    integer, intent(in) :: nb_cont_node0
    integer, intent(in) :: nb_cont_node
    integer, pointer, intent(in) :: v_poin_node(:)
    integer, pointer, intent(in) :: v_list_node(:)
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_CONTACT
!
! Suppress multiple nodes - Copy in contact datastructure
!
! --------------------------------------------------------------------------------------------------
!
! In  sdcont_defi      : name of contact definition datastructure (from DEFI_CONTACT)
! In  nb_cont_surf     : number of surfaces of contact
! In  nb_cont_node0    : number of nodes of contact (before detection of multiple node)
! In  nb_cont_node     : number of nodes of contact (after detection of multiple node)
! In  v_list_node      : pointer to list of non-double nodes
! In  v_poin_node      : pointer to pointer of contact surface
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_surf, i_node
    character(len=24) :: sdcont_noeuco
    integer, pointer :: v_sdcont_noeuco(:) => null()
    character(len=24) :: sdcont_psunoco
    integer, pointer :: v_sdcont_psunoco(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
!
! - Datastructure for contact definition
!
    sdcont_noeuco  = sdcont_defi(1:16)//'.NOEUCO'
    sdcont_psunoco = sdcont_defi(1:16)//'.PSUNOCO'
    call jeveuo(sdcont_noeuco , 'E', vi = v_sdcont_noeuco)
    call jeveuo(sdcont_psunoco, 'E', vi = v_sdcont_psunoco)

! - PSUNOCO pointer modification
!
    do i_surf = 1, nb_cont_surf
        v_sdcont_psunoco(i_surf+1) = v_sdcont_psunoco(i_surf+1) - v_poin_node(i_surf+1)
    end do
!
! - Copy of nodes
!
    do i_node = 1, nb_cont_node
        v_sdcont_noeuco(i_node) = v_list_node(i_node)
    end do
!
! - New length of NOEUCO
!
    do i_node = nb_cont_node + 1, nb_cont_node0
        v_sdcont_noeuco(i_node) = 0
    end do
    call jeecra(sdcont_noeuco, 'LONUTI', ival=nb_cont_node)
!
end subroutine
