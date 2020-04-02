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
subroutine existGrpNo(mesh, group_no, l_exi_in_grp, l_exi_in_grp_p)
!
    implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/isParallelMesh.h"
#include "asterfort/jexnom.h"
#include "asterfort/jenonu.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeexin.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jeveuo.h"
!
    character(len=8), intent(in) :: mesh
    character(len=*), intent(in) :: group_no
    aster_logical, intent(out) ::  l_exi_in_grp, l_exi_in_grp_p
!
!---------------------------------------------------------------------------------------------------
!   But :
!     To know if a group of nodes is in a GROUP_NO of the mesh
!
!   IN:
!     mesh      : name of the mesh
!     group_no  : name of the group of nodes to test
!
!   OUT:
!     l_exi_in_grp : the group of nodes is in GROUP_NO (for a parallel mesh, it means that the
!                    group of nodes is in the local mesh)
!     l_exi_in_grp_p : the group of nodes is in PAR_GRPNOE but not necessaraly in GROUP_NO
!                      of the local mesh (for a parallel mesh, it means that the
!                      group of nodes is in GROUP_NO of the global mesh
!                      but not necessaraly in the local mesh )
!
! Note that for a parallel mesh, l_exi_in_grp and l_exi_in_grp_p are not necerally equal where are
! they are equal for a non-parallel mesh
!
!---------------------------------------------------------------------------------------------------
    integer :: iret, iGr, nb_grpp
    character(len=24) :: grnoma, grnomap
    aster_logical :: l_parallel_mesh
    character(len=24), pointer :: v_grpp(:) => null()
!-----------------------------------------------------------------------
!
    l_exi_in_grp   = ASTER_FALSE
    l_exi_in_grp_p = ASTER_FALSE
    grnoma         = mesh//'.GROUPENO'
    grnomap        = mesh//'.PAR_GRPNOE'
!
    call jemarq()
!
    l_parallel_mesh = isParallelMesh(mesh)
!
    if(l_parallel_mesh) then
        call jeexin(grnoma, iret)
        if(iret .ne. 0) then
            call jenonu(jexnom(grnoma, group_no), iret)
!
            if(iret .ne. 0) then
                l_exi_in_grp   = ASTER_TRUE
            end if
        end if
        call jeexin(grnomap, iret)
        if(iret .ne. 0) then
            call jeveuo(grnomap, 'L' , vk24=v_grpp)
            nb_grpp = size(v_grpp)
            do iGr = 1, nb_grpp
                if(v_grpp(iGr) == group_no) then
                    l_exi_in_grp_p = ASTER_TRUE
                    exit
                end if
            end do
        end if
    else
        call jeexin(grnoma, iret)
        if(iret .ne. 0) then
            call jenonu(jexnom(grnoma, group_no), iret)
!
            if(iret .ne. 0) then
                l_exi_in_grp   = ASTER_TRUE
                l_exi_in_grp_p = ASTER_TRUE
            end if
        end if
    end if
!
    call jedema()
end subroutine
