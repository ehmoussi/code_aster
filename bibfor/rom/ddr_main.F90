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
subroutine ddr_main(cmdPara)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/ddr_comp.h"
#include "asterfort/ddr_crid.h"
#include "asterfort/infniv.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
#include "asterfort/ddr_prep.h"
!
type(ROM_DS_ParaDDR), intent(in) :: cmdPara
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_DOMAINE_REDUIT - Main process
!
! Compute EIM (DEIM method) and apply for two bases
!
! --------------------------------------------------------------------------------------------------
!
! In  cmdPara          : datastructure for parameters of EIM computation
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nb_node_rid, nbModePrim, nbModeDual
    integer, pointer :: v_equa_prim(:) => null()
    integer, pointer :: v_equa_dual(:) => null()
    integer, pointer :: v_list_rid(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
!
! - Get parameters
!
    nbModePrim = cmdPara%ds_empi_prim%nbMode
    nbModeDual = cmdPara%ds_empi_dual%nbMode
!
! - Prepare working objects
!
    AS_ALLOCATE(vi = v_equa_prim, size = nbModePrim)
    AS_ALLOCATE(vi = v_equa_dual, size = nbModeDual)
!
! - Application of DEIM
!    
    call ddr_comp(cmdPara%ds_empi_prim, v_equa_prim)
    call ddr_comp(cmdPara%ds_empi_dual, v_equa_dual)
!
! - Prepare list of nodes in RID
!
    call ddr_prep(cmdPara, v_equa_prim, v_equa_dual, v_list_rid, nb_node_rid)
!
! - Create RID on the mesh from list
!
    call ddr_crid(cmdPara, nb_node_rid, v_list_rid)
!
! - Clean
!
    AS_DEALLOCATE(vi=v_equa_prim)
    AS_DEALLOCATE(vi=v_equa_dual)
    AS_DEALLOCATE(vi=v_list_rid)
!
end subroutine
