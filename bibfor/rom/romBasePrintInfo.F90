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
subroutine romBasePrintInfo(base)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
#include "asterfort/romModePrintInfo.h"
!
type(ROM_DS_Empi), intent(in) :: base
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Base management
!
! Print informations about base
!
! --------------------------------------------------------------------------------------------------
!
! In  base             : base
!
! --------------------------------------------------------------------------------------------------
!
    call utmess('I', 'ROM12_10')
    if (base%nbMode .ne. 0) then
        call utmess('I', 'ROM12_11', si = base%nbMode)
    endif
    if (base%baseType .eq. 'LINEIQUE') then
        call utmess('I', 'ROM12_12')
        call utmess('I', 'ROM12_13', sk = base%lineicAxis)
        call utmess('I', 'ROM12_14', sk = base%lineicSect)
    else
        call utmess('I', 'ROM12_15')
    endif
    if (base%nbSnap .ne. 0) then
        call utmess('I', 'ROM12_16', si = base%nbSnap)
    endif
    call utmess('I', 'ROM12_17')
    call romModePrintInfo(base%mode)
!
end subroutine
