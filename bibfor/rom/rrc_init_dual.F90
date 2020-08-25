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
subroutine rrc_init_dual(cmdPara)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/infniv.h"
#include "asterfort/jelira.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/romFieldEquaToEqua.h"
#include "asterfort/romFieldNodeFromEqua.h"
#include "asterfort/rsexch.h"
#include "asterfort/utmess.h"
!
type(ROM_DS_ParaRRC), intent(inout) :: cmdPara
!
! --------------------------------------------------------------------------------------------------
!
! REST_REDUIT_COMPLET - Initializations
!
! Initializations for dual base
!
! --------------------------------------------------------------------------------------------------
!
! IO  cmdPara          : datastructure for parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=24) :: fieldName, fieldRom, fieldDom
    character(len=8) :: mesh, resultRom
    integer, pointer  :: listNode(:) => null()
    integer :: nbNodeMesh, nbEquaRom, iret, nbEquaDom
    integer :: noeq, nord
    integer :: nb_cmp_node, nb_node_grno
    integer :: iNode, iCmp, iEqua
    integer, pointer  :: v_grno(:) => null()
    integer, pointer  :: v_int_dual(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM6_39')
    endif
!
! - Get parameters
!
    resultRom = cmdPara%result_rom
    fieldName = cmdPara%ds_empi_dual%ds_mode%fieldName
    mesh      = cmdPara%ds_empi_dual%ds_mode%mesh
    call dismoi('NB_NO_MAILLA', mesh, 'MAILLAGE', repi = nbNodeMesh)
!
! - Get representative field on reduced domain
!
    call rsexch(' ', resultRom, fieldName, 1, fieldRom, iret)
    if (iret .ne. 0) then
        call utmess('F', 'ROM7_25', sk = fieldName)
    endif
    call jelira(fieldRom(1:19)//'.VALE', 'LONMAX', nbEquaRom)
!
! - Get representative field on complete domain: the mode !
!
    fieldDom  = cmdPara%ds_empi_dual%ds_mode%fieldRefe
    nbEquaDom = cmdPara%ds_empi_dual%ds_mode%nbEqua
    nb_cmp_node = cmdPara%ds_empi_dual%ds_mode%nbCmpName
!
! - Create list of nodes on all mesh
!
    AS_ALLOCATE(vi = listNode, size = nbNodeMesh)
!
! - Detect nodes on all mesh with equation from reduced domain
!
    call romFieldNodeFromEqua(fieldRom, nbEquaRom, nbNodeMesh, listNode)
!
! - Get link between equation in complete domain and equation in reduced domain
!
    cmdPara%nb_equa_ridd = nbEquaRom
    AS_ALLOCATE(vi = cmdPara%v_equa_ridd, size = nbEquaDom)
    call romFieldEquaToEqua(fieldDom, fieldRom, listNode, cmdPara%v_equa_ridd)
!
! - Access to GROUP_NO at interface
!
    call jelira(jexnom(mesh//'.GROUPENO', cmdPara%grnode_int), 'LONUTI', nb_node_grno)
    call jeveuo(jexnom(mesh//'.GROUPENO', cmdPara%grnode_int), 'L'     , vi = v_grno)
!
! - Create list of equations at interface
!
    ASSERT(nb_cmp_node*nb_node_grno .le. nbEquaDom)
    AS_ALLOCATE(vi = v_int_dual, size = nbEquaDom)
    do iNode = 1, nb_node_grno
        do iCmp = 1, nb_cmp_node
            v_int_dual(iCmp+nb_cmp_node*(v_grno(iNode)-1)) = 1
        enddo
    enddo
    AS_ALLOCATE(vi = cmdPara%v_equa_ridi, size = nbEquaDom)
    noeq = 0
    nord = 0
    do iEqua = 1, nbEquaDom
        if (cmdPara%v_equa_ridd(iEqua) .ne. 0) then
            nord = nord + 1
            if (v_int_dual(iEqua) .eq. 0) then
                noeq = noeq + 1
                cmdPara%v_equa_ridd(iEqua) = noeq
                cmdPara%v_equa_ridi(nord)  = noeq
            else
                cmdPara%v_equa_ridd(iEqua) = 0
            endif
        endif
    enddo
    cmdPara%nb_equa_ridi = nbEquaRom - nb_node_grno*nb_cmp_node
!
! - Clean
!
    AS_DEALLOCATE(vi = listNode)
    AS_DEALLOCATE(vi = v_int_dual)
!
end subroutine
