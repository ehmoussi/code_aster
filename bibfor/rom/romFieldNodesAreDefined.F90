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
subroutine romFieldNodesAreDefined(field  , listEqua, numeDof  ,&
                                   grnode_, nbNode_ , listNode_)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/as_allocate.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/jelira.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/select_dof.h"
#include "asterfort/utmess.h"
!
type(ROM_DS_Field), intent(in) :: field
integer, pointer :: listEqua(:)
character(len=24), intent(in) :: numeDof
character(len=24), optional, intent(in) :: grnode_
integer, optional, intent(in) :: nbNode_
integer, pointer, optional :: listNode_(:)
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Field management
!
! Detect if an equation in the field is defined for given list of nodes
!
! --------------------------------------------------------------------------------------------------
!
! In  field            : field
! Ptr listEqua         : pointer to list of equations
!                           for iEqua = [1, nbEqua]
!                               listEqua[iEqua] = 1 if equation is for node in the list
!                               listEqua[iEqua] = 0 if equation is not for node in the list
! In  grnode           : name of GROUP_NO
!<or>
! In  nbNode           : number of nodes
! In  listNode         : list of nodes
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nbNode, nbEqua
    character(len=24) :: fieldRefe
    character(len=8) :: mesh
    integer, pointer :: listNodeFromGroup(:) => null()
    character(len=4) :: fieldSupp
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM11_8')
    endif
!
! - Get parameters
!
    mesh      = field%mesh
    nbEqua    = field%nbEqua
    fieldSupp = field%fieldSupp
    fieldRefe = field%fieldRefe
    ASSERT(fieldSupp .eq. 'NOEU')
!
! - Access to list of nodes
!
    if (present(grnode_)) then
        call jelira(jexnom(mesh//'.GROUPENO', grnode_), 'LONUTI', nbNode)
        call jeveuo(jexnom(mesh//'.GROUPENO', grnode_), 'L'     , vi = listNodeFromGroup)
    else
        nbNode = nbNode_
    endif
!
! - Create list of equations
!
    AS_ALLOCATE(vi = listEqua, size = nbEqua)
!
! - Find index of equations
!
    if (present(listNode_)) then
        call select_dof(listEqua_      = listEqua ,&
                        numeDofZ_      = numeDof,&
                        nbNodeToSelect_= nbNode, listNodeToSelect_ = listNode_)
    else
        call select_dof(listEqua_      = listEqua ,&
                        numeDofZ_      = numeDof,&
                        nbNodeToSelect_= nbNode, listNodeToSelect_ = listNodeFromGroup)
    endif
!
end subroutine
