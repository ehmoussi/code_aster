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
subroutine dbrInitBasePod(baseName, paraPod, lReuse, base)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/infniv.h"
#include "asterfort/modelNodeEF.h"
#include "asterfort/nonlinDSTableIOCreate.h"
#include "asterfort/romBaseCreate.h"
#include "asterfort/romBaseGetInfo.h"
#include "asterfort/romLineicPrepNume.h"
#include "asterfort/romResultCreateMode.h"
#include "asterfort/romTableCreate.h"
#include "asterfort/utmess.h"
!
character(len=8), intent(in) :: baseName
type(ROM_DS_ParaDBR_POD), intent(inout) :: paraPod
aster_logical, intent(in) :: lReuse
type(ROM_DS_Empi), intent(inout) :: base
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE
!
! Initializations for base - For POD methods
!
! --------------------------------------------------------------------------------------------------
!
! In  baseName         : name of base
! IO  paraPod          : datastructure for parameters (POD)
! In  lReuse           : .true. if reuse
! IO  base             : base
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nbNodeWithDof
    character(len=8) :: model
    type(ROM_DS_Field) :: mode
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM18_10')
    endif
!
! - Create base
!
    if (.not. lReuse) then
        base%resultName = baseName
        call romBaseCreate(base, paraPod%nbModeMaxi)
    endif
!
! - Create datastructure of table in results datastructure for the reduced coordinates
!
    call romTableCreate(baseName, paraPod%tablReduCoor%tablResu)
!
! - Create table in results datastructure (if necessary)
!
    call nonlinDSTableIOCreate(paraPod%tablReduCoor%tablResu)
!
! - Get previous base
!
    if (lReuse) then
        call romBaseGetInfo(baseName, base)
    endif
!
! - Create mode datastructure from representative field in high-fidelity result
!
    if (.not. lReuse) then
        call romResultCreateMode(paraPod%resultDom, paraPod%fieldName, mode)
    endif
!
! - Create datastructure for base
!
    if (.not. lReuse) then
        base%resultName = baseName
        base%mode       = mode
        base%baseType   = paraPod%baseType
        base%lineicAxis = paraPod%lineicAxis
        base%lineicSect = paraPod%lineicSect
        base%nbMode     = 0
        base%nbSnap     = 0
    endif
!
! - Create numbering of nodes for the lineic model
!
    if (base%baseType .eq. 'LINEIQUE') then
        if (niv .ge. 2) then
            call utmess('I', 'ROM18_11')
        endif
        model = base%mode%model
        call modelNodeEF(model, nbNodeWithDof)
        call romLineicPrepNume(base, nbNodeWithDof)
    endif
!
end subroutine
