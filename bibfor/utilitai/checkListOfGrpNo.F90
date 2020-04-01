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
subroutine checkListOfGrpNo(mesh, listGrpNo, nbGrpNo, l_stop_local)
!
    implicit none
!
#include "asterf_types.h"
#include "asterfort/existGrpNo.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/utmess.h"
!
    character(len=*), intent(in)    :: mesh
    character(len=*), intent(in)    :: listGrpNo(*)
    integer, intent(in)             :: nbGrpNo
    aster_logical, intent(in)       :: l_stop_local
!
!---------------------------------------------------------------------------------------------------
!   But :
!     Check list of group of nodes
!
!   IN:
!     mesh         : name of the mesh
!     l_stop_local : emmit Fatal error if a groups of nodes is not in the local mesh
!     listGrpNo : list of groups of nodes to check in the local mesh
!     nbGrpNo   : number of groups of nodes in the list
!
!---------------------------------------------------------------------------------------------------
    character(len=24) :: grpNoName, valk(2)
    integer :: iGrpNo
    aster_logical ::  l_exi_in_grp, l_exi_in_grp_p
!-----------------------------------------------------------------------
!
    call jemarq()
!
    do iGrpNo = 1, nbGrpNo
        grpNoName = listGrpNo(iGrpNo)
        call existGrpNo(mesh(1:8), grpNoName, l_exi_in_grp, l_exi_in_grp_p)
!
! --- The group of nodes exists in the global mesh
!
        if (l_exi_in_grp_p) then
!
! --- The group of nodes does not exist in the local mesh
!
            if (.not.l_exi_in_grp .and. l_stop_local) then
                valk(1) = grpNoName
                valk(2) = mesh
                call utmess('F', 'MODELISA7_75', nk=2, valk=valk)
            endif
        else
            valk(1) = grpNoName
            valk(2) = mesh
            call utmess('F', 'MODELISA7_75', nk=2, valk=valk)
        endif
    end do
!
    call jedema()
!
end subroutine
