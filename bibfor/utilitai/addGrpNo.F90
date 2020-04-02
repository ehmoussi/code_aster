! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
! person_in_charge: nicolas.pignet at edf.fr
!
subroutine addGrpNo(mesh, group_no, listNodes, nbNodes, l_added_grpno)
!
    implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/existGrpNo.h"
#include "asterfort/isParallelMesh.h"
#include "asterfort/jecroc.h"
#include "asterfort/jedema.h"
#include "asterfort/jeecra.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/juveca.h"
#include "asterfort/utmess.h"
!
    character(len=8), intent(in)  :: mesh
    character(len=24), intent(in) :: group_no
    integer, intent(in)           :: listNodes(*)
    integer, intent(in)           :: nbNodes
    aster_logical, intent(out), optional :: l_added_grpno
!
!---------------------------------------------------------------------------------------------------
!   But :
!     Add a group of nodes in a GROUP_NO of the mesh
!
!   IN:
!     mesh      : name of the mesh
!     group_no  : name of the group of nodes to test
!     listNodes : list of nodes of group_no
!     nbNdoes   : number of nodes
!
!  OUT:
!     l_added_grpno : the group_no has been added to the mesh ?
!
!---------------------------------------------------------------------------------------------------
    character(len=24) :: grnoma, grnomap
    integer :: nbGrp
    aster_logical :: l_parallel_mesh, l_exi_in_grp, l_exi_in_grp_p, l_added
    integer, pointer :: v_nodes(:) => null()
    character(len=24), pointer :: v_grpp(:) => null()
!-----------------------------------------------------------------------
!
    grnoma         = mesh//'.GROUPENO'
    grnomap        = mesh//'.PAR_GRPNOE'
!
    call jemarq()
!
    l_parallel_mesh = isParallelMesh(mesh)
!
    call existGrpNo(mesh, group_no, l_exi_in_grp, l_exi_in_grp_p)
!
! --- The group already exists - do nothing
!
    if(l_exi_in_grp) then
        l_added = ASTER_FALSE
        call utmess('A', 'MODELISA7_9', sk=group_no)
    else
        l_added = ASTER_TRUE
        ASSERT(.not.l_exi_in_grp)
!
! --- Add group_no
!
        call jecroc(jexnom(grnoma, group_no))
        call jeecra(jexnom(grnoma, group_no), 'LONMAX', max(nbNodes, 1))
        call jeecra(jexnom(grnoma, group_no), 'LONUTI', nbNodes)
        call jeveuo(jexnom(grnoma, group_no), 'E', vi=v_nodes)
!
! --- Add nodes
!
        v_nodes(1:nbNodes) = listNodes(1:nbNodes)
!
! --- For a ParallelMesh, add new group_no to global group_no
!
        if(l_parallel_mesh) then
            if(.not.l_exi_in_grp_p) then
                call jeveuo(grnomap, 'L', vk24=v_grpp)
                nbGrp = size(v_grpp)
                call juveca(grnomap, nbGrp+1)
                call jeveuo(grnomap, 'L', vk24=v_grpp)
                v_grpp(nbGrp+1) = group_no
!
! --- Becarefull, there are not yet shared by all meshes
!
            end if
        end if
    end if
!
    if(present(l_added_grpno)) then
        l_added_grpno = l_added
    end if
!
    call jedema()
end subroutine
