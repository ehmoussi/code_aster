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
subroutine romFieldNodeFromEqua(fieldRefe, nbEqua, nbNodeMesh, listNode)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/infniv.h"
#include "asterfort/jelira.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
!
character(len=24), intent(in) :: fieldRefe
integer, intent(in) :: nbEqua, nbNodeMesh
integer, pointer :: listNode(:)
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Field management
!
! Detect if node has equation defined in the field
!
! --------------------------------------------------------------------------------------------------
!
! In  field            : field
! In  nbNodeMesh       : number of nodes in mesh
! Ptr listNode         : pointer to list of nodes in mesh
!                       for iNode =  [1:nbNodeMesh]
!                           listNode[iNode] = 0 if node+component not present
!                           listNode[iNode] = 1 if node+component is present
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer, pointer :: deeq(:) => null()
    character(len=19) :: profChno
    integer :: iEqua, iNodeMesh
    integer :: numeEqua, numeNode, numeCmp
    integer :: nbEquaChck, nbCmpOnNode
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM11_7')
    endif
!
! - Get parameters
!
    !ASSERT(fieldSupp .eq. 'NOEU')
!
! - Properties of field
!
    call dismoi('PROF_CHNO', fieldRefe, 'CHAM_NO', repk = profChno)
    call jeveuo(profChno(1:19)//'.DEEQ', 'L', vi = deeq)
    call jelira(fieldRefe(1:19)//'.VALE', 'LONMAX', nbEquaChck)
    ASSERT(nbEquaChck .eq. nbEqua)
!
! - Convert
!
    do iEqua = 1, nbEqua
! ----- Get current equation
        numeEqua = iEqua

! ----- Detect {Node,C mp} on current equation
        numeNode = deeq(2*(numeEqua-1)+1)
        numeCmp  = deeq(2*(numeEqua-1)+2)

! ----- Physical node
        if (numeNode .gt. 0 .and. numeCmp .gt. 0) then
            listNode(numeNode) = listNode(numeNode) + 1
        endif

! ----- Non-Physical node (Lagrange)
        if (numeNode .gt. 0 .and. numeCmp .lt. 0) then
            ASSERT(ASTER_FALSE)
        endif

! ----- Non-Physical node (Lagrange) - LIAISON_DDL
        if (numeNode .eq. 0 .and. numeCmp .eq. 0) then
            ASSERT(ASTER_FALSE)
        endif
    end do
!
! - Set value
!
    do iNodeMesh = 1, nbNodeMesh
        nbCmpOnNode = listNode(iNodeMesh)
        if (nbCmpOnNode .ne. 0) then
            listNode(iNodeMesh) = iNodeMesh
        endif
    end do
!
end subroutine
