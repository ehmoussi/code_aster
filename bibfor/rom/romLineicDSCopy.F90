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
subroutine romLineicDSCopy(lineicNumeIn, lineicNumeOut)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/as_allocate.h"
!
type(ROM_DS_LineicNumb), intent(in) :: lineicNumeIn
type(ROM_DS_LineicNumb), intent(out) :: lineicNumeOut
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Copy datastructure of lineic numbering
!
! --------------------------------------------------------------------------------------------------
!
! In  lineicNumeIn          :  input lineic numbering
! Out lineicNumeOut          : output lineic numbering
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iSlice, nbSlice
!
! --------------------------------------------------------------------------------------------------
!

    nbSlice                = lineicNumeIn%nbSlice
    lineicNumeOut%nbSlice  = lineicNumeIn%nbSlice
    lineicNumeOut%toleNode = lineicNumeIn%toleNode
    lineicNumeOut%nbCmp    = lineicNumeIn%nbCmp
!
! - Copy pointers
!
    if (nbSlice .gt. 0) then
        AS_ALLOCATE(vi = lineicNumeOut%numeSlice, size = nbSlice)
        AS_ALLOCATE(vi = lineicNumeOut%numeSection, size = nbSlice)
        do iSlice = 1, nbSlice
            lineicNumeOut%numeSlice(iSlice) = lineicNumeIn%numeSlice(iSlice)
            lineicNumeOut%numeSection(iSlice) = lineicNumeIn%numeSection(iSlice)
        end do
    endif
!
end subroutine
