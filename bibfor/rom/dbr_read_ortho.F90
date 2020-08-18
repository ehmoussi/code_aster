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
subroutine dbr_read_ortho(paraOrtho)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/getvid.h"
#include "asterfort/getvr8.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
!
type(ROM_DS_ParaDBR_ORTHO), intent(inout) :: paraOrtho
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE
!
! Read parameters - For orthogonalization
!
! --------------------------------------------------------------------------------------------------
!
! IO  paraOrtho        : datastructure for parameters (orthogonalization)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nocc
    character(len=8) :: base_init
    real(kind=8) :: alpha
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM18_4')
    endif
!
! - Initializations
!
    base_init = ' '
    alpha     = 0.d0
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
    paraOrtho%alpha     = alpha
    paraOrtho%base_init = base_init
!
end subroutine
