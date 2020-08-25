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
subroutine romFieldPrintInfo(field)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
!
type(ROM_DS_Field), intent(in) :: field
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Field management
!
! Print informations about field
!
! --------------------------------------------------------------------------------------------------
!
! In  mode             : mode
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iCmpName
!
! --------------------------------------------------------------------------------------------------
!
    call utmess('I', 'ROM11_50', sk = field%fieldName)
    call utmess('I', 'ROM11_51', si = field%nbEqua)
    if (field%fieldSupp .eq. 'NOEU') then
        call utmess('I', 'ROM11_52')
    elseif (field%fieldSupp .eq. 'ELGA') then
        call utmess('I', 'ROM11_53')
    else
        ASSERT(ASTER_FALSE)
    endif
    call utmess('I', 'ROM11_54', si = field%nbCmpName)
    do iCmpName = 1, field%nbCmpName
        call utmess('I', 'ROM11_55', si = iCmpName, sk = field%listCmpName(iCmpName))
    end do
    if (field%lLagr) then
        call utmess('I', 'ROM11_56')
    endif
!
end subroutine
