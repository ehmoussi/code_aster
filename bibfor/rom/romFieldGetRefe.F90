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
subroutine romFieldGetRefe(resultNameZ  , modelZ,&
                           nbFieldResult, resultField, resultFieldNume, &
                           fieldName    , field)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/rsexch.h"
#include "asterfort/romFieldGetInfo.h"
!
character(len=*), intent(in) :: resultNameZ, modelZ
integer, intent(in)  :: nbFieldResult
character(len=16), pointer :: resultField(:)
integer, pointer :: resultFieldNume(:)
character(len=24), intent(in)  :: fieldName
type(ROM_DS_Field), intent(inout) :: field
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Field management
!
! Get representative field in results datastructure
!
! --------------------------------------------------------------------------------------------------
!
! In  resultName       : name of results datastructure
! In  model            : model
! In  nbFieldResult    : number of _active_ fields type in results datastructure
! Ptr resultField      : pointer to type of active fields in results datastructure
! Ptr resultFieldNume  : pointer to a storing index which is valid for active field
! In  fieldName        : name of field (NOM_CHAM)
! IO  field            : representative field 
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iFieldResult, numeStore, iret
    character(len=24) :: fieldRefe
    character(len=8) :: model
!
! --------------------------------------------------------------------------------------------------
!
    model = modelZ
!
! - Get representative storing index
!
    do iFieldResult = 1, nbFieldResult
        if (fieldName .eq. resultField(iFieldResult)) then
            numeStore = resultFieldNume(iFieldResult)
            exit
        endif
    end do
    ASSERT(numeStore .ge. 0)
!
! - Get representative field
!
    call rsexch(' ', resultNameZ, fieldName, numeStore, fieldRefe, iret)
    ASSERT(iret .eq. 0)
!
! - Create field
!
    call romFieldGetInfo(model, fieldName, fieldRefe, field)
!
end subroutine
