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
subroutine ddr_chck(cmdPara)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/jeexin.h"
#include "asterfort/jenonu.h"
#include "asterfort/jexnom.h"
#include "asterfort/romModeChck.h"
#include "asterfort/utmess.h"
!
type(ROM_DS_ParaDDR), intent(in) :: cmdPara
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_DOMAINE_REDUIT - Initializations
!
! Some checks
!
! --------------------------------------------------------------------------------------------------
!
! In  cmdPara          : datastructure for parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: iret
    character(len=24) :: grelem_rid, grnode_int
    type(ROM_DS_Empi) :: basePrim, baseDual
    character(len=8) :: meshPrim, meshDual, mesh
    type(ROM_DS_Field) :: modePrim, modeDual
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM19_3')
    endif
!
! - Get parameters in datastructure
!
    mesh       = cmdPara%mesh
    basePrim   = cmdPara%ds_empi_prim
    baseDual   = cmdPara%ds_empi_dual
    grelem_rid = cmdPara%grelem_rid
    grnode_int = cmdPara%grnode_int
!
! - Check modes
!
    modePrim = basePrim%mode
    modeDual = baseDual%mode
    call romModeChck(modePrim)
    call romModeChck(modeDual)
    if (modePrim%fieldSupp .ne. 'NOEU' .or. modeDual%fieldSupp .ne. 'NOEU') then
        call utmess('F','ROM4_11')
    endif
!
! - Check mesh
!
    meshPrim = basePrim%mode%mesh
    meshDual = baseDual%mode%mesh
    if (meshPrim .ne. meshDual) then
        call utmess('F','ROM4_9')
    endif
    if (mesh .ne. meshPrim) then
        call utmess('F','ROM4_10')
    endif
!
! - Check groups
!
    call jeexin(mesh//'.GROUPENO', iret)
    if (iret .ne. 0) then
        call jenonu(jexnom(mesh//'.GROUPENO', grnode_int), iret)
        if (iret .ne. 0) then
            call utmess('F', 'ROM4_12', sk = grnode_int)
        endif
    endif
    call jeexin(mesh//'.GROUPEMA', iret)
    if (iret .ne. 0) then
        call jenonu(jexnom(mesh//'.GROUPEMA', grelem_rid), iret)
        if (iret .ne. 0) then
            call utmess('F', 'ROM4_13', sk = grelem_rid)
        endif
    endif
!
! - Check consistency of fields for modes
!
    if (modePrim%fieldName .eq. 'TEMP') then
        if (modeDual%fieldName .ne. 'FLUX_NOEU') then
            call utmess('F', 'ROM4_17', sk = 'FLUX_NOEU')
        endif
    elseif (modePrim%fieldName .eq. 'DEPL') then
        if (modeDual%fieldName .ne. 'SIEF_NOEU') then
            call utmess('F', 'ROM4_17', sk = 'SIEF_NOEU')
        endif
    else
        call utmess('F', 'ROM4_16')
    endif
!
end subroutine
