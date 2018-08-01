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
subroutine dbr_chck_tr(ds_para_tr)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/utmess.h"
#include "asterfort/dismoi.h"
#include "asterfort/romBaseChck.h"
!
type(ROM_DS_ParaDBR_TR), intent(in) :: ds_para_tr
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Initializations
!
! Some checks - Truncation
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_para_tr       : datastructure for truncation parameters
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: model_rom, model_init
    character(len=8) :: mesh_rom, mesh_init
!
! --------------------------------------------------------------------------------------------------
!
    model_init = ds_para_tr%ds_empi_init%model
    model_rom  = ds_para_tr%model_rom
    mesh_init  = ds_para_tr%ds_empi_init%mesh
    call dismoi('NOM_MAILLA', model_rom, 'MODELE'  , repk = mesh_rom)
    if (mesh_init .ne. mesh_rom) then
        call utmess('F', 'ROM6_12')
    endif
    if (model_init .eq. model_rom) then
        call utmess('F', 'ROM6_13')
    endif
!
! - Check empiric base
!
    call romBaseChck(ds_para_tr%ds_empi_init)
!
end subroutine
