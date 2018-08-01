! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
subroutine ddr_chck(ds_para)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/jeexin.h"
#include "asterfort/jenonu.h"
#include "asterfort/jexnom.h"
!
type(ROM_DS_ParaDDR), intent(in) :: ds_para
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_DOMAINE_REDUIT - Initializations
!
! Some checks
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_para          : datastructure for parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: iret
    character(len=24) :: grelem_rid  = ' ', grnode_int  = ' '
    type(ROM_DS_Empi) :: empi_prim, empi_dual
    character(len=8) :: mesh_prim, mesh_dual, model_prim, model_dual, mesh
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM5_10')
    endif
!
! - Get parameters in datastructure
!
    mesh       = ds_para%mesh
    empi_prim  = ds_para%ds_empi_prim
    empi_dual  = ds_para%ds_empi_dual
    grelem_rid = ds_para%grelem_rid
    grnode_int = ds_para%grnode_int
!
! - Check mesh
!
    mesh_prim = empi_prim%mesh
    mesh_dual = empi_dual%mesh
    if (mesh_prim .ne. mesh_dual) then
        call utmess('F','ROM4_9')
    endif
    if (mesh .ne. mesh_prim) then
        call utmess('F','ROM4_10')
    endif
!
! - Check model
!
    model_prim = empi_prim%model
    model_dual = empi_dual%model
    if (model_prim .eq. '#PLUSIEURS' .or. model_dual .eq. '#PLUSIEURS') then
        call utmess('F','ROM4_11')
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
! - Check fields for empiric modes
!
    if (empi_prim%field_name .eq. 'TEMP') then
        if (empi_dual%field_name .ne. 'FLUX_NOEU') then
            call utmess('F', 'ROM4_17', sk = 'FLUX_NOEU')
        endif
    elseif (empi_prim%field_name .eq. 'DEPL') then
        if (empi_dual%field_name .ne. 'SIEF_NOEU') then
            call utmess('F', 'ROM4_17', sk = 'SIEF_NOEU')
        endif
    else
        call utmess('F', 'ROM4_16')
    endif
!
end subroutine
