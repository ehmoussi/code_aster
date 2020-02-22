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
subroutine dbr_read_ortho(ds_para_ortho)
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
#include "asterfort/getvr8.h"
!
type(ROM_DS_ParaDBR_ORTHO), intent(inout) :: ds_para_ortho
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Initializations
!
! Read parameters - For truncation
!
! --------------------------------------------------------------------------------------------------
!
! IO  ds_para_ortho    : datastructure for orthogonalization parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nocc, ifm, niv
    character(len=8) :: base_init
    real(kind=8) :: alpha
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM5_28')
    endif
!
    base_init = ' '
    alpha = 0.d0
!
! - Get parameters
!
    call getvid(' ', 'BASE', scal = base_init, nbret = nocc)
    if (nocc .eq. 0) then
        base_init = ' '
    endif
    call getvr8(' ', 'ALPHA', scal = alpha, nbret = nocc)
    ASSERT(nocc .eq. 1)
!
! - Save parameters in datastructure
!
    ds_para_ortho%alpha     = alpha
    ds_para_ortho%base_init = base_init
!
end subroutine
