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
subroutine romFieldBuildClean(fieldBuild)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/romBaseClean.h"
#include "asterfort/romFieldClean.h"
!
type(ROM_DS_FieldBuild), intent(inout) :: fieldBuild
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Field build
!
! Clean field build datastructure
!
! --------------------------------------------------------------------------------------------------
!
! In  fieldBuild       : field build
!
! --------------------------------------------------------------------------------------------------
!
    call romFieldClean(fieldBuild%fieldRom)
    call romFieldClean(fieldBuild%fieldDom)
    call romBaseClean(fieldBuild%base)
    AS_DEALLOCATE(vi = fieldBuild%equaRIDTotal)
    AS_DEALLOCATE(vi = fieldBuild%equaRIDTrunc)
    AS_DEALLOCATE(vr = fieldBuild%matrPhi)
    AS_DEALLOCATE(vr = fieldBuild%matrPhiRID)
    AS_DEALLOCATE(vr = fieldBuild%fieldTransientVale)
    if (fieldBuild%operation .eq. 'GAPPY_POD') then
        AS_DEALLOCATE(vr = fieldBuild%reduMatr)
    endif
!
end subroutine
