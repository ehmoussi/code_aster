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
subroutine dbrInitBaseTrunc(resultName, paraTrunc, lReuse, base)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/dbrInitProfTrunc.h"
#include "asterfort/infniv.h"
#include "asterfort/romBaseCreate.h"
#include "asterfort/romBaseDSCopy.h"
#include "asterfort/romBaseGetInfo.h"
#include "asterfort/utmess.h"
!
character(len=8), intent(in) :: resultName
type(ROM_DS_ParaDBR_Trunc), intent(inout) :: paraTrunc
aster_logical, intent(in) :: lReuse
type(ROM_DS_Empi), intent(inout) :: base
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE
!
! Initializations for base - For truncation
!
! --------------------------------------------------------------------------------------------------
!
! In  resultName       : name of results datastructure to save base
! IO  paraTrunc        : datastructure for parameters (truncation)
! In  lReuse           : .true. if reuse
! IO  base             : base
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=8) :: resultNameIn
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM18_16')
    endif
!
! - Get informations about base to truncate
!
    if (lReuse) then
        if (niv .ge. 2) then
            call utmess('I', 'ROM18_17')
        endif
        call romBaseGetInfo(resultName, base)
        resultNameIn = resultName
    else
        if (niv .ge. 2) then
            call utmess('I', 'ROM18_18')
        endif
        resultNameIn = paraTrunc%baseInitName
        call romBaseGetInfo(resultNameIn, paraTrunc%baseInit)
    endif
!
! - Create PROF_CHNO for truncation
!
    if (niv .ge. 2) then
        call utmess('I', 'ROM18_19')
    endif
    call dbrInitProfTrunc(resultNameIn, resultName, paraTrunc)
!
! - Create base (if necessary)
!
    if (.not. lReuse) then
        if (niv .ge. 2) then
            call utmess('I', 'ROM18_20')
        endif
        call romBaseDSCopy(paraTrunc%baseInit, resultName, base)
        call romBaseCreate(base, paraTrunc%baseInit%nbMode)
    endif
!
! - If reuse: check that name is the name between output result end keyword BASE
!
    if (lReuse) then
        if (paraTrunc%baseInitName .ne. resultName) then
            call utmess('F', 'ROM18_21')
        endif
    endif
!
end subroutine
