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
subroutine irnono(meshNameZ , meshNbNode  ,&
                  nbNode    , nodeName    ,&
                  nbGrNode  , grNodeName  ,&
                  nodeSelect, nbNodeSelect,&
                  nodeFlag)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/utmess.h"
!
character(len=*), intent(in) :: meshNameZ
integer, intent(in) :: meshNbNode
integer, intent(in) :: nbNode
character(len=8), pointer :: nodeName(:)
integer, intent(in) :: nbGrNode
character(len=24), pointer :: grNodeName(:)
integer, pointer :: nodeSelect(:)
integer, intent(out) :: nbNodeSelect
integer, pointer :: nodeFlag(:)
!
! --------------------------------------------------------------------------------------------------
!
! Print results
!
! Select nodes from user
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: meshName
    integer :: iNode, nodeNume, iGrNode, iret, grNodeNbNode
    integer, pointer :: listNode(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    meshName     = meshNameZ
    nbNodeSelect = 0
!
! - Select nodes by name
!
    if (nbNode .ne. 0) then
        do iNode = 1, nbNode
            call jenonu(jexnom(meshName//'.NOMNOE', nodeName(iNode)), nodeNume)
            if (nodeNume .eq. 0) then
                call utmess('A', 'RESULT3_6', sk=nodeName(iNode))
                nodeName(iNode) = ' '
            else
                if (nodeFlag(nodeNume) .eq. 0) then
                    nbNodeSelect = nbNodeSelect + 1
                    ASSERT(nbNodeSelect .le. meshNbNode)
                    nodeSelect(nbNodeSelect) = nodeNume
                    nodeFlag(nodeNume) = 1
                endif
            endif
        end do
    endif
!
! - Select nodes in groups of nodes
!
    if (nbGrNode .ne. 0) then
        do iGrNode = 1, nbGrNode
            call jeexin(jexnom(meshName//'.GROUPENO', grNodeName(iGrNode)), iret)
            if (iret .eq. 0) then
                call utmess('A', 'RESULT3_7', sk=grNodeName(iGrNode))
                grNodeName(iGrNode) = ' '
            else
                call jelira(jexnom(meshName//'.GROUPENO', grNodeName(iGrNode)),&
                            'LONMAX', grNodeNbNode)
                if (grNodeNbNode .eq. 0) then
                    call utmess('A', 'RESULT3_8', sk=grNodeName(iGrNode))
                    grNodeName(iGrNode) = ' '
                else
                    call jeveuo(jexnom(meshName//'.GROUPENO', grNodeName(iGrNode)),&
                                'L', vi = listNode)
                    do iNode = 1, grNodeNbNode
                        nodeNume = listNode(iNode)
                        if (nodeFlag(nodeNume) .eq. 0) then
                            nbNodeSelect = nbNodeSelect + 1
                            ASSERT(nbNodeSelect .le. meshNbNode)
                            nodeSelect(nbNodeSelect) = nodeNume
                            nodeFlag(nodeNume) = 1
                        endif
                    end do
                endif
            endif
        end do
    endif
!
    call jedema()
end subroutine
