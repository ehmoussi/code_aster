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
subroutine dbrReadGreedy(paraGreedy)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/cresol.h"
#include "asterfort/getvis.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/infniv.h"
#include "asterfort/romMultiParaRead.h"
#include "asterfort/utmess.h"
!
type(ROM_DS_ParaDBR_Greedy), intent(inout) :: paraGreedy
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE
!
! Read parameters - For greedy method
!
! --------------------------------------------------------------------------------------------------
!
! IO  paraGreedy       : datastructure for parameters (Greedy)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nbModeMaxi, nocc
    character(len=16) :: stabFSI, orthoBase
    aster_logical :: lStabFSI, lOrthoBase
    real(kind=8) :: toleGreedy
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM18_2')
    endif
!
! - Initializations
!
    stabFSI    = ' '
    orthoBase  = ' '
    nbModeMaxi = 0
!
! - Maximum number of modes
!
    call getvis(' ', 'NB_MODE' , scal = nbModeMaxi, nbret = nocc)
    ASSERT(nocc .eq. 1 .and. nbModeMaxi .ge. 1)
!
! - If we orthogonalize basis
!
    call getvtx(' ', 'ORTHO_BASE', scal = orthoBase)
    lOrthoBase = orthoBase .eq. 'OUI'
!
! - If we stabilise the basis for FSI transient problem
!
    call getvtx(' ', 'TYPE_BASE', scal = stabFSI)
    lStabFSI = stabFSI .eq. 'IFS_STAB'
!
! - Read tolerance
!
    call getvr8(' ', 'TOLE_GLOUTON', scal = toleGreedy)
!
! - Read data for multiparametric problems
!
    call romMultiParaRead(paraGreedy%multiPara)
!
! - Read solver parameters
!
    call cresol(paraGreedy%solver)
!
! - Save parameters in datastructure
!
    paraGreedy%nbModeMaxi = nbModeMaxi
    paraGreedy%lOrthoBase = lOrthoBase
    paraGreedy%lStabFSI   = lStabFSI
    paraGreedy%toleGreedy = toleGreedy
!
end subroutine
