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
subroutine romBaseDSCopy(baseIn, resultName, baseOut)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/romModeDSCopy.h"
#include "asterfort/romLineicDSCopy.h"
!
type(ROM_DS_Empi), intent(in)  :: baseIn
character(len=8), intent(in)   :: resultName
type(ROM_DS_Empi), intent(out) :: baseOut
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Base management
!
! Copy datastructure of base
!
! --------------------------------------------------------------------------------------------------
!
! In  baseIn                 : input base
! In  resultName             : name of output base
! Out baseOut                : output base
!
! --------------------------------------------------------------------------------------------------
!
    baseOut%resultName = resultName
    baseOut%baseType   = baseIn%baseType
    baseOut%lineicAxis = baseIn%lineicAxis
    baseOut%lineicSect = baseIn%lineicSect
    baseOut%nbMode     = baseIn%nbMode
    baseOut%lineicNume = baseIn%lineicNume
!
! - Copy lineic numbering
!
    call romLineicDSCopy(baseIn%lineicNume, baseOut%lineicNume)
!
! - Copy mode
!
    call romModeDSCopy(baseIn%mode, baseOut%mode)
!
end subroutine
