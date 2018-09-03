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

subroutine cfleno(sdcont_defi , nb_cont_surf, nb_cont_node0, v_list_node, v_poin_node,&
                  nb_cont_node)
!
implicit none
!
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
#include "asterfort/assert.h"
#include "asterfort/cfnbsf.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeveuo.h"
#include "asterfort/wkvect.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=24), intent(in) :: sdcont_defi
    integer, intent(in) :: nb_cont_surf
    integer, intent(in) :: nb_cont_node0
    integer, intent(inout) :: nb_cont_node
    integer, pointer :: v_poin_node(:)
    integer, pointer :: v_list_node(:)
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_CONTACT
!
! Suppress multiple nodes - Create list of double nodes in the same contact surface
!
! --------------------------------------------------------------------------------------------------
!
! In  sdcont_defi      : name of contact definition datastructure (from DEFI_CONTACT)
! In  nb_cont_surf     : number of surfaces of contact
! In  nb_cont_node0    : number of nodes of contact (before detection of multiple nodes)
! IO  nb_cont_node     : number of nodes of contact (after detection of multiple nodes)
! Out v_list_node      : pointer to list of non-double nodes
! Out v_poin_node      : pointer to pointer of contact surface
!
! --------------------------------------------------------------------------------------------------
!
    integer :: jdecno
    integer :: i_surf, i_node, ii, node_nume_1, node_nume_2, k
    integer :: nb_node_elim, nb_node
    integer, pointer :: v_node_indx(:) => null()
    character(len=24) :: sdcont_noeuco
    integer, pointer :: v_sdcont_noeuco(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    nb_node_elim = 0
!
! - Datastructure for contact definition
!
    sdcont_noeuco = sdcont_defi(1:16)//'.NOEUCO'
    call jeveuo(sdcont_noeuco, 'E', vi = v_sdcont_noeuco)
!
! - Temporary vectors
!
    AS_ALLOCATE(vi=v_node_indx, size=nb_cont_node)
    AS_ALLOCATE(vi=v_poin_node, size=nb_cont_surf+1)
!
! - Double-node detection
!
    do i_surf = 1, nb_cont_surf
        v_poin_node(i_surf+1) = v_poin_node(i_surf)
        call cfnbsf(sdcont_defi, i_surf, 'NOEU', nb_node, jdecno)
        do 20 i_node = 1, nb_node
            node_nume_1 = v_sdcont_noeuco(jdecno+i_node)
            do ii = 1, i_node - 1
                node_nume_2 = v_sdcont_noeuco(jdecno+ii)
                if (node_nume_1 .eq. node_nume_2) then
                    v_node_indx(jdecno+i_node) = 1
                    v_poin_node(i_surf+1) = v_poin_node(i_surf+1) + 1
                    nb_node_elim = nb_node_elim + 1
                    goto 20
                endif
            end do
20      continue
    end do
!
! - Non-suppressed nodes vector
!
    nb_cont_node = nb_cont_node0 - nb_node_elim
    AS_ALLOCATE(vi=v_list_node, size=nb_cont_node)
!
! - Copy list of non-suppressed nodes
!
    k = 0
    do i_node = 1, nb_cont_node0
        if (v_node_indx(i_node) .eq. 0) then
            k = k + 1
            v_list_node(k) = v_sdcont_noeuco(i_node)
        endif
    end do
    ASSERT(k.eq.nb_cont_node)
!
! - Clean
!
    AS_DEALLOCATE(vi=v_node_indx)
!
end subroutine
