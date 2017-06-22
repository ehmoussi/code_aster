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

subroutine elimcq(sdcont, mesh, nb_cont_zone, nb_cont_surf, nb_cont_node)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
#include "asterfort/cfleq8.h"
#include "asterfort/cfmeno.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: sdcont
    character(len=8), intent(in) :: mesh
    integer, intent(in) :: nb_cont_zone
    integer, intent(in) :: nb_cont_surf
    integer, intent(inout) :: nb_cont_node
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_CONTACT
!
! Suppress middle nodes from QUAD8
!
! --------------------------------------------------------------------------------------------------
!
! In  sdcont           : name of contact concept (DEFI_CONTACT)
! In  mesh             : name of mesh
! In  nb_cont_zone     : number of zones of contact
! In  nb_cont_surf     : number of surfaces of contact
! IO  nb_cont_node     : number of nodes of contact
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_cont_node0
    character(len=24) :: sdcont_defi
    integer, pointer :: v_poin_node(:) => null()
    integer, pointer :: v_list_node(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    sdcont_defi   = sdcont(1:8)//'.CONTACT'
!
! - Create list of middle nodes
!
    nb_cont_node0 = nb_cont_node
    call cfleq8(mesh         , sdcont_defi, nb_cont_zone, nb_cont_surf, nb_cont_node,&
                nb_cont_node0, v_list_node, v_poin_node )
!
! - List of nodes update
!
    if (nb_cont_node0 .ne. nb_cont_node) then
        call cfmeno(sdcont_defi, nb_cont_surf, nb_cont_node0, v_list_node, v_poin_node,&
                    nb_cont_node)
    endif
!
    AS_DEALLOCATE(vi=v_poin_node)
    AS_DEALLOCATE(vi=v_list_node)
!
end subroutine
