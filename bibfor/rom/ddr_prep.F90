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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine ddr_prep(cmdPara, v_equa_prim, v_equa_dual, v_node_rid, nbNodeRID)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utlisi.h"
#include "asterfort/romConvertEquaToNode.h"
!
type(ROM_DS_ParaDDR), intent(in) :: cmdPara
integer, pointer :: v_equa_prim(:)
integer, pointer :: v_equa_dual(:)
integer, pointer :: v_node_rid(:)
integer, intent(out) :: nbNodeRID
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_DOMAINE_REDUIT - Main process
!
! Prepare list of nodes in RID
!
! --------------------------------------------------------------------------------------------------
!
! In  cmdPara          : datastructure for parameters of EIM computation
! In  v_equa_prim      : list of equations selected by DEIM method (magic points) - Primal
! In  v_equa_dual      : list of equations selected by DEIM method (magic points) - Dual
! Out v_node_rid       : list of nodes in RID (absolute number from mesh)
! Out nbNodeRID        : number of nodes in RID
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nbModePrim, nbModeDual, nbModeTotal
    integer :: nbRidMini
    integer :: iNodeRID
    integer, pointer :: v_list_unio1(:) => null()
    integer, pointer :: v_list_unio2(:) => null()
    character(len=24) :: modePrimRefe, modeDualRefe
    integer, pointer :: v_node_prim(:) => null()
    integer, pointer :: v_node_dual(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
!
! - Initializations
!
    nbNodeRID   = 0
!
! - Get parameters
!
    nbModePrim   = cmdPara%ds_empi_prim%nbMode
    modePrimRefe = cmdPara%ds_empi_prim%mode%fieldRefe
    nbModeDual   = cmdPara%ds_empi_dual%nbMode
    modeDualRefe = cmdPara%ds_empi_dual%mode%fieldRefe
    nbModeTotal  = nbModePrim + nbModeDual
    nbRidMini    = cmdPara%nb_rid_mini
    ASSERT(cmdPara%ds_empi_prim%mode%fieldSupp .eq. 'NOEU')
    ASSERT(cmdPara%ds_empi_dual%mode%fieldSupp .eq. 'NOEU')
!
! - Prepare working objects
!
    AS_ALLOCATE(vi = v_list_unio1, size = nbModeTotal)
    AS_ALLOCATE(vi = v_list_unio2, size = nbModeTotal+nbRidMini)
!
! - "convert" equations to nodes
!
    AS_ALLOCATE(vi = v_node_prim, size = nbModePrim)
    AS_ALLOCATE(vi = v_node_dual, size = nbModeDual)
    call romConvertEquaToNode(modePrimRefe, nbModePrim, v_equa_prim, v_node_prim)
    call romConvertEquaToNode(modeDualRefe, nbModeDual, v_equa_dual, v_node_dual)
!
! - Assembling the two lists to find a list of interpolated points
!
    call utlisi('UNION'     ,&
                v_node_prim , nbModePrim ,&
                v_node_dual , nbModeDual ,&
                v_list_unio1, nbModeTotal, nbNodeRID)
!
! - Add minimum domain (if required)
!
    if (nbRidMini .gt. 0) then
        call utlisi('UNION'     ,&
                    v_list_unio1      , nbNodeRID,&
                    cmdPara%v_rid_mini, nbRidMini,&
                    v_list_unio2      , nbModeTotal+nbRidMini, nbNodeRID)
    endif
!
! - List of nodes in RID
!
    AS_ALLOCATE(vi = v_node_rid , size = nbNodeRID)
    do iNodeRID = 1, nbNodeRID
        if (nbRidMini .eq. 0) then
            v_node_rid(iNodeRID) = v_list_unio1(iNodeRID)
        else
            v_node_rid(iNodeRID) = v_list_unio2(iNodeRID)
        endif
    enddo
    if (niv .ge. 2) then
        call utmess('I', 'ROM4_25', si = nbNodeRID)
    endif
!
! - Clean
!
    AS_DEALLOCATE(vi=v_list_unio1)
    AS_DEALLOCATE(vi=v_list_unio2)
    AS_DEALLOCATE(vi=v_node_prim)
    AS_DEALLOCATE(vi=v_node_dual)
!
end subroutine
