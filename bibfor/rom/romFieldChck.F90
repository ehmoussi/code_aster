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
subroutine romFieldChck(ds_field, fieldName_)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/indik8.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
!
type(ROM_DS_Field), intent(in) :: ds_field
character(len=*), optional, intent(in) :: fieldName_
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Check components in field
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_field         : datastructure for field
! In  fieldName        : name of field where empiric modes have been constructed
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: fieldName
    integer :: nbCmpChck, nbCmp
    integer :: iCmp, iCmpChck, cmpIndx
    character(len=8) :: chckCmpName(6), cmpName
!
! --------------------------------------------------------------------------------------------------
!
    fieldName = ' '
    nbCmp     = ds_field%nbCmp
    if (present(fieldName_)) then
        fieldName = fieldName_
    else
        fieldName = ds_field%fieldName
    endif
!
! - List of components authorized in field
!
    if (fieldName .eq. 'TEMP') then
        nbCmpChck      = 1
        chckCmpName(1) = 'TEMP'
    elseif (fieldName .eq. 'DEPL') then
        nbCmpChck      = 3
        chckCmpName(1) = 'DX'
        chckCmpName(2) = 'DY'
        chckCmpName(3) = 'DZ'
    elseif (fieldName .eq. 'FLUX_NOEU') then
        nbCmpChck      = 3
        chckCmpName(1) = 'FLUX'
        chckCmpName(2) = 'FLUY'
        chckCmpName(3) = 'FLUZ'
    elseif (fieldName .eq. 'SIEF_NOEU') then
        nbCmpChck      = 6
        chckCmpName(1) = 'SIXX'
        chckCmpName(2) = 'SIYY'
        chckCmpName(3) = 'SIZZ'
        chckCmpName(4) = 'SIXZ'
        chckCmpName(5) = 'SIYZ'
        chckCmpName(6) = 'SIXY'
    elseif (fieldName .eq. 'UPPHI_2D') then
        nbCmpChck      = 4
        chckCmpName(1) = 'DX'
        chckCmpName(2) = 'DY'
        chckCmpName(3) = 'PRES'
        chckCmpName(4) = 'PHI'
    elseif (fieldName .eq. 'UPPHI_3D') then
        nbCmpChck      = 5
        chckCmpName(1) = 'DX'
        chckCmpName(2) = 'DY'
        chckCmpName(3) = 'DZ'
        chckCmpName(4) = 'PRES'
        chckCmpName(5) = 'PHI'
    else
        ASSERT(ASTER_FALSE)
    endif
!
! - Required components
!
    do iCmpChck = 1, nbCmpChck
        cmpName = chckCmpName(iCmpChck)
        cmpIndx = indik8(ds_field%listCmpName, chckCmpName(iCmpChck), 1, nbCmp)
        if (cmpIndx .eq. 0) then
            call utmess('F', 'ROM5_25', sk = cmpName)
        endif
    end do
!
! - Forbidden components
!
    do iCmp = 1, nbCmp
        cmpName = ds_field%listCmpName(iCmp)
        cmpIndx = indik8(chckCmpName, cmpName, 1, nbCmpChck)
        if (cmpIndx .eq. 0) then
            call utmess('F', 'ROM5_23', sk = cmpName)
        endif
    end do
!
end subroutine
