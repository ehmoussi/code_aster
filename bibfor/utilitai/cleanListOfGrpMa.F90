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
subroutine cleanListOfGrpMa(mesh, listGrpMa, nbGrpMa, l_stop, iret)
!
    implicit none
!
#include "asterf_types.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/existGrpMa.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/utmess.h"
!
    character(len=*), intent(in)    :: mesh
    character(len=*), intent(inout) :: listGrpMa(*)
    integer, intent(inout)          :: nbGrpMa
    aster_logical, intent(in)       :: l_stop
    integer, intent(out)            :: iret
!
!---------------------------------------------------------------------------------------------------
!   But :
!     Clean list of groups of cells to get only the groups of cells in GROUP_MA
!
!   IN:
!     mesh       : name of the mesh
!     l_stop     : emmit Fatal error if a group of cells is not in the global mesh
!
!   IN/OUT:
!     listGrpMa : list of groups of cells to clean in the local mesh
!     nbCell    : number of groups of cells in the list
!                 (before and after cleaning in the local mesh)
!
!   OUT:
!     iret    : 0 - the list has been modified
!             : 1 - the list has not been modified
!
!
!---------------------------------------------------------------------------------------------------
    character(len=24) :: GrpMaName, valk(2)
    integer :: nbGrpMaTmp, iGrpMa
    aster_logical ::  l_exi_in_grp, l_exi_in_grp_p
    character(len=24), pointer :: listGrpMaTmp(:) => null()
!-----------------------------------------------------------------------
!
    if(nbGrpMa == 0) then
        iret = 1
        go to 999
    end if
!
    call jemarq()
!
! --- Initialisation
!
    AS_ALLOCATE(vk24=listGrpMaTmp, size=nbGrpMa)
    nbGrpMaTmp     = 0
!
    do iGrpMa = 1, nbGrpMa
        GrpMaName = listGrpMa(iGrpMa)
        call existGrpMa(mesh(1:8), GrpMaName, l_exi_in_grp, l_exi_in_grp_p)
!
! --- The group of cells exists in the global mesh
!
        if (l_exi_in_grp_p) then
!
! --- The group of cells exist in the local mesh
!
            if (l_exi_in_grp) then
                nbGrpMaTmp = nbGrpMaTmp + 1
                listGrpMaTmp(nbGrpMaTmp) = GrpMaName
            endif
        else
            if(l_stop) then
                valk(1) = GrpMaName
                valk(2) = mesh
                call utmess('F', 'MODELISA7_77', nk=2, valk=valk)
            end if
        endif
    end do
!
    if(nbGrpMaTmp < nbGrpMa) then
        iret = 0
    else
        iret = 1
    end if
!
! --- Copy list of cleanning groups of cells
!
    do iGrpMa = 1, nbGrpMaTmp
        listGrpMa(iGrpMa) = listGrpMaTmp(iGrpMa)
    end do
!
    do iGrpMa = nbGrpMaTmp + 1, nbGrpMa
        listGrpMa(iGrpMa) = " "
    end do
!
    nbGrpMa = nbGrpMaTmp
!
    AS_DEALLOCATE(vk24= listGrpMaTmp)
!
    call jedema()
!
999 continue
!
end subroutine
