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

subroutine fieldNodeHasConstantProfile(fieldz, lConst)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/jelira.h"
#include "asterfort/jeveuo.h"
!
character(len=*), intent(in) :: fieldz
aster_logical, intent(out) :: lConst
!
! --------------------------------------------------------------------------------------------------
!
! Fields
!
! Check if all nodes have same number of components
!
! --------------------------------------------------------------------------------------------------
!
! In  field         : name of field
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: mesh
    character(len=16) :: fieldSupp
    character(len=19) :: field
    integer, pointer :: deeq(:) => null()
    integer, pointer :: nodeNbCmp(:) => null()
    character(len=19) :: profChno
    integer :: iNode, iEqua
    integer :: numeNode, numeCmp
    integer :: nbNodeMesh, nbEqua, nbCmpNode, nbCmp
!
! --------------------------------------------------------------------------------------------------
!
    field  = fieldz
    lConst = ASTER_TRUE
!
! - Informations about field
!
    call dismoi('TYPE_CHAMP', field, 'CHAMP', repk = fieldSupp)
    ASSERT(fieldSupp .eq. 'NOEU')
    call dismoi('NOM_MAILLA', field, 'CHAM_NO', repk = mesh)
    call dismoi('NB_NO_MAILLA', mesh, 'MAILLAGE', repi = nbNodeMesh)
    call dismoi('PROF_CHNO', field, 'CHAM_NO', repk = profChno)
    call jeveuo(profChno(1:19)//'.DEEQ', 'L', vi = deeq)
    call jelira(field(1:19)//'.VALE', 'LONMAX', nbEqua)
!
! - Create object
!
    AS_ALLOCATE(vi = nodeNbCmp, size = nbNodeMesh)
!
! - Look for nodes
!
    do iEqua = 1, nbEqua
        numeNode = deeq(2*(iEqua-1)+1)
        numeCmp  = deeq(2*(iEqua-1)+2)
        if (numeNode .gt. 0 .and. numeCmp .gt. 0) then
            nodeNbCmp(numeNode) = nodeNbCmp(numeNode) + 1
        endif
    end do
!
! - Check for constant number of components by node
!
    nbCmpNode = 0
    do iNode = 1, nbNodeMesh
        if (nbCmpNode .eq. 0) then
            nbCmpNode = nodeNbCmp(iNode)
        else
            nbCmp = nodeNbCmp(iNode)
            if (nbCmp .ne. 0 .and. nbCmp.ne. nbCmpNode) then
                lConst = ASTER_FALSE
            endif
        endif
    end do
!
    AS_DEALLOCATE(vi = nodeNbCmp)
!
end subroutine
