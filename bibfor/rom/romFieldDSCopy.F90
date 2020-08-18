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
subroutine romFieldDSCopy(fieldIn, fieldOut)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/as_allocate.h"
!
type(ROM_DS_Field), intent(in)  :: fieldIn
type(ROM_DS_Field), intent(inout) :: fieldOut
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Field management
!
! Copy datastructure of field
!
! --------------------------------------------------------------------------------------------------
!
! In  fieldIn          : input field
! IO  fieldOut         : output field
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iCmpName, nbCmpName, iEqua, nbEqua
!
! --------------------------------------------------------------------------------------------------
!

!
! - Copy static variables
!
    fieldOut%fieldName = fieldIn%fieldName
    fieldOut%fieldRefe = fieldIn%fieldRefe
    fieldOut%fieldSupp = fieldIn%fieldSupp
    fieldOut%mesh      = fieldIn%mesh
    fieldOut%model     = fieldIn%model
    fieldOut%nbEqua    = fieldIn%nbEqua
    fieldOut%lLagr     = fieldIn%lLagr
    fieldOut%nbCmpName = fieldIn%nbCmpName
!
! - Copy pointers
!
    nbCmpName = fieldIn%nbCmpName
    if (nbCmpName .ne. 0) then
        AS_ALLOCATE(vk8 = fieldOut%listCmpName, size = nbCmpName)
        do iCmpName = 1, nbCmpName
            fieldOut%listCmpName(iCmpName) = fieldIn%listCmpName(iCmpName)
        end do
    endif
    nbEqua = fieldIn%nbEqua
    if (nbEqua .ne. 0) then
        AS_ALLOCATE(vi = fieldOut%equaCmpName, size = nbEqua)
        do iEqua = 1, nbEqua
            fieldOut%equaCmpName(iEqua) = fieldIn%equaCmpName(iEqua)
        end do
    endif
!
end subroutine
