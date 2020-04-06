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
subroutine cleanListOfGrpNo(mesh, listGrpNo, nbGrpNo, l_stop, iret)
!
    implicit none
!
#include "asterf_types.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/existGrpNo.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/utmess.h"
!
    character(len=*), intent(in)    :: mesh
    character(len=*), intent(inout) :: listGrpNo(*)
    integer, intent(inout)          :: nbGrpNo
    aster_logical, intent(in)       :: l_stop
    integer, intent(out)            :: iret
!
!---------------------------------------------------------------------------------------------------
!   But :
!     Clean list of group of nodes to get only the groups in GROUP_NO
!
!   IN:
!     mesh       : name of the mesh
!     l_stop     : emmit Fatal error if a node is not in the global mesh
!
!   IN/OUT:
!     listGrpNo : list of groups of nodes to clean in the local mesh
!     nbGrpNo   : number of groups of nodes in the list
!                 (before and after cleaning in the local mesh)
!
!   OUT:
!     iret    : 0 - the list has been modified
!             : 1 - the list has not been modified
!
!
!---------------------------------------------------------------------------------------------------
    character(len=24) :: grpNoName, valk(2)
    integer :: nbGrpNoTmp, iGrpNo
    aster_logical ::  l_exi_in_grp, l_exi_in_grp_p
    character(len=24), pointer :: listGrpNoTmp(:) => null()
!-----------------------------------------------------------------------
!
    if(nbGrpNo == 0) then
        iret = 1
        go to 999
    end if
!
    call jemarq()
!
! --- Initialisation
!
    AS_ALLOCATE(vk24=listGrpNoTmp, size=nbGrpNo)
    nbGrpNoTmp     = 0
!
    do iGrpNo = 1, nbGrpNo
        grpNoName = listGrpNo(iGrpNo)
        call existGrpNo(mesh(1:8), grpNoName, l_exi_in_grp, l_exi_in_grp_p)
!
! --- The group of nodes exists in the global mesh
!
        if (l_exi_in_grp_p) then
!
! --- The group of nodes exist in the local mesh
!
            if (l_exi_in_grp) then
                nbGrpNoTmp = nbGrpNoTmp + 1
                listGrpNoTmp(nbGrpNoTmp) = grpNoName
            endif
        else
            if(l_stop) then
                valk(1) = grpNoName
                valk(2) = mesh
                call utmess('F', 'MODELISA7_75', nk=2, valk=valk)
            end if
        endif
    end do
!
    if(nbGrpNoTmp < nbGrpNo) then
        iret = 0
    else
        iret = 1
    end if
!
! --- Copy list of cleanning group of nodes
!
    do iGrpNo = 1, nbGrpNoTmp
        listGrpNo(iGrpNo) = listGrpNoTmp(iGrpNo)
    end do
!
    do iGrpNo = nbGrpNoTmp + 1, nbGrpNo
        listGrpNo(iGrpNo) = " "
    end do
!
    nbGrpNo = nbGrpNoTmp
!
    AS_DEALLOCATE(vk24= listGrpNoTmp)
!
    call jedema()
!
999 continue
!
end subroutine
