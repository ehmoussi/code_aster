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
subroutine dbr_read_tr(ds_para_tr, l_base)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/getvid.h"
!
type(ROM_DS_ParaDBR_TR), intent(inout) :: ds_para_tr
aster_logical, intent(out) :: l_base
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Initializations
!
! Read parameters - For truncation
!
! --------------------------------------------------------------------------------------------------
!
! IO  ds_para_tr       : datastructure for truncation parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nocc, ifm, niv
    character(len=8) :: model_rom = ' ',  base_init = ' '
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM5_29')
    endif
!
! - Get parameters
!
    call getvid(' ', 'MODELE_REDUIT', scal = model_rom, nbret = nocc)
    ASSERT(nocc .eq. 1)
    call getvid(' ', 'BASE', scal = base_init, nbret = nocc)
    if (nocc .eq. 0) then
        base_init   = ' '
        l_base = ASTER_FALSE
    else
        l_base = ASTER_TRUE
    endif
!
! - Save parameters in datastructure
!
    ds_para_tr%model_rom   = model_rom
    ds_para_tr%base_init   = base_init
!
end subroutine
