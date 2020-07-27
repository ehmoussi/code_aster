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
subroutine romResultSetZero(resultName, numeStore, ds_mode)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/copisd.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rsexch.h"
#include "asterfort/rsnoch.h"
!
character(len=8), intent(in) :: resultName
integer, intent(in) :: numeStore
type(ROM_DS_Field), intent(in) :: ds_mode
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Set zero value in resultName datastructure
!
! --------------------------------------------------------------------------------------------------
!
! In  resultName       : name of results datastructure
! In  numeStore       : index to set zero in results
! In  ds_mode          : datastructure for empiric mode
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: iret
    character(len=24) :: resultField
    real(kind=8), pointer :: v_resultField(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM6_33', si = numeStore)
    endif
!
! - Set zero
!
    call rsexch(' ', resultName, ds_mode%fieldName, numeStore, resultField, iret)
    ASSERT(iret .eq. 100)
    call copisd('CHAMP_GD', 'G', ds_mode%fieldRefe, resultField)
    if (ds_mode%fieldSupp .eq. 'NOEU') then
        call jeveuo(resultField(1:19)//'.VALE', 'E', vr = v_resultField)
        v_resultField(:) = 0.d0
    else
        ASSERT(ASTER_FALSE)
    endif
    call rsnoch(resultName, ds_mode%fieldName, numeStore)
!
end subroutine
