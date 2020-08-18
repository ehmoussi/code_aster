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
subroutine romResultCreateMode(result, fieldName, mode)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
#include "asterfort/romFieldGetInfo.h"
#include "asterfort/rs_getfirst.h"
#include "asterfort/rsadpa.h"
#include "asterfort/rsexch.h"
!
type(ROM_DS_Result), intent(in) :: result
character(len=24), intent(in) :: fieldName
type(ROM_DS_Field), intent(inout) :: mode
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Create mode datastructure from representative field in result
!
! --------------------------------------------------------------------------------------------------
!
! In  result           : result
! In  fieldName        : name of field (NOM_CHAM) for mode
! IO  mode             : mode
!
! --------------------------------------------------------------------------------------------------
!
    integer :: numeStoreFirst
    character(len=8) :: model
    character(len=24) :: fieldRefe
    integer :: iret, nbStore, jvPara
    character(len=8) :: resultName
    character(len=16) :: resultType
!
! --------------------------------------------------------------------------------------------------
!
    fieldRefe  = ' '
    resultName = result%resultName
    resultType = result%resultType
    nbStore    = result%nbStore
!
! - Some checks
!
    ASSERT(resultType .eq. 'EVOL_NOLI' .or. resultType .eq. 'EVOL_THER')
    ASSERT(nbStore .ge. 1)
!
! - Select _representative_ field in result: the first one !
!
    call rs_getfirst(resultName, numeStoreFirst)
!
! - Get model
!
    call rsadpa(resultName, 'L', 1, 'MODELE'   , numeStoreFirst, 0, sjv=jvPara)
    model = zk8(jvPara)
!
! - Get _representative_ field in result
!
    call rsexch(' ', resultName, fieldName, numeStoreFirst, fieldRefe, iret)
    if (iret .ne. 0) then
        call utmess('F', 'ROM13_10', sk = fieldName)
    endif
!
! - Get informations from field
!
    call romFieldGetInfo(model, fieldName, fieldRefe, mode)
!
! - Get components in fields
!
    if (mode%lLagr) then
        call utmess('F', 'ROM13_11')
    endif
!
end subroutine
