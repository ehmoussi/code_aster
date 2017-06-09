! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

subroutine nmextt(ds_inout, field_type, field_disc)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/nmetob.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(NL_DS_InOut), intent(in) :: ds_inout
    character(len=24), intent(in) :: field_type
    character(len=4), intent(out) :: field_disc
!
! --------------------------------------------------------------------------------------------------
!
! *_NON_LINE - Field extraction datastructure
!
! Get localization of field (discretization: NOEU, ELGA or ELEM)
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_inout         : datastructure for input/output management
! In  field_type       : type of field (name in results datastructure)
! Out field_disc       : localization of field (discretization: NOEU, ELGA or ELEM)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_field
!
! --------------------------------------------------------------------------------------------------
!
    field_disc = 'XXXX'
!
! - Index of field
!
    call nmetob(ds_inout, field_type, i_field)
!
! - Get localization of field
!
    field_disc = ds_inout%field(i_field)%disc_type
!
! - Check
!
    ASSERT(field_disc.eq.'NOEU'.or.field_disc.eq.'ELGA'.or.field_disc.eq.'ELEM')

end subroutine
