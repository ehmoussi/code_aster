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
subroutine dbrReadTrunc(paraTrunc)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/getvid.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
!
type(ROM_DS_ParaDBR_Trunc), intent(inout) :: paraTrunc
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE
!
! Read parameters - For truncation
!
! --------------------------------------------------------------------------------------------------
!
! IO  paraTrunc        : datastructure for parameters (truncation)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nocc
    character(len=8) :: modelRom, baseInitName
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM18_3')
    endif
!
! - Initializations
!
    modelRom     = ' '
    baseInitName = ' '
!
! - Get parameters
!
    call getvid(' ', 'MODELE_REDUIT', scal = modelRom, nbret = nocc)
    ASSERT(nocc .eq. 1)
    call getvid(' ', 'BASE', scal = baseInitName, nbret = nocc)
    if (nocc .eq. 0) then
        baseInitName = ' '
    endif
!
! - Save parameters in datastructure
!
    paraTrunc%modelRom     = modelRom
    paraTrunc%baseInitName = baseInitName
!
end subroutine
