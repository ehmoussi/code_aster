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
subroutine dbr_chck_tr(paraTrunc, lReuse)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/utmess.h"
#include "asterfort/dismoi.h"
#include "asterfort/romModeChck.h"
!
type(ROM_DS_ParaDBR_TR), intent(in) :: paraTrunc
aster_logical, intent(in) :: lReuse
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Initializations
!
! Some checks - Truncation
!
! --------------------------------------------------------------------------------------------------
!
! In  paraTrunc        : datastructure for truncation parameters
! In  lReuse           : .true. if reuse
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: baseModel, modeModel
    character(len=8) :: baseMesh, modeMesh, baseInit
    type(ROM_DS_Field) :: mode
!
! --------------------------------------------------------------------------------------------------
!
    mode      = paraTrunc%ds_empi_init%mode
    modeModel = mode%model
    modeMesh  = mode%mesh
    baseModel = paraTrunc%model_rom
    call dismoi('NOM_MAILLA', baseModel, 'MODELE'  , repk = baseMesh)
    if (modeMesh .ne. baseMesh) then
        call utmess('F', 'ROM6_12')
    endif
    if (modeModel .eq. baseModel) then
        call utmess('F', 'ROM6_13')
    endif
!
! - Check empiric mode
!
    call romModeChck(mode)
!
! - No reuse:
!
    baseInit = paraTrunc%base_init
    if (lReuse) then
        if (baseInit .ne. ' ') then
            call utmess('F', 'ROM6_40')
        endif
    endif
!
! - Only on nodal fields 
!
    if (mode%fieldSupp .ne. 'NOEU') then
        call utmess('F','ROM2_2')
    endif
!
end subroutine
