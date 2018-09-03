! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
subroutine romResultSetZero(result, nume_store, ds_mode)
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
character(len=8), intent(in) :: result
integer, intent(in) :: nume_store
type(ROM_DS_Field), intent(in) :: ds_mode
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Set zero value in result datastructure
!
! --------------------------------------------------------------------------------------------------
!
! In  result           : name of results datastructure
! In  nume_store       : index to set zero in results
! In  ds_mode          : datastructure for empiric mode
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: iret
    character(len=24) :: field_save
    real(kind=8), pointer :: v_field_save(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM6_33', si = nume_store)
    endif
!
! - Set zero
!
    call rsexch(' ', result, ds_mode%field_name, nume_store, field_save, iret)
    ASSERT(iret .eq. 100)
    call copisd('CHAMP_GD', 'G', ds_mode%field_refe, field_save)
    call jeveuo(field_save(1:19)//'.VALE', 'E', vr = v_field_save)
    v_field_save(:) = 0.d0
    call rsnoch(result, ds_mode%field_name, nume_store)
!
end subroutine
