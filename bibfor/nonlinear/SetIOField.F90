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

subroutine SetIOField(ds_inout  , field_type,&
                      l_read_   , l_acti_,&
                      disc_type_)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(NL_DS_InOut), intent(inout) :: ds_inout
    character(len=*), intent(in) :: field_type
    aster_logical, optional, intent(in) :: l_read_
    aster_logical, optional, intent(in) :: l_acti_
    character(len=*), optional, intent(in) :: disc_type_
!
! --------------------------------------------------------------------------------------------------
!
! *_NON_LINE - Input/output management
!
! Set values for field
!
! --------------------------------------------------------------------------------------------------
!
! IO  ds_inout         : datastructure for input/output management
! In  field_type       : type of field (symbolic name in result datastructure)
! In  l_read           : .true. if this field is read
! In  l_acti           : .true. if this field is activated
! In  disc_type        : type of discretization (ELEM, ELGA, ...)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_field_type, i_field, nb_field
!
! --------------------------------------------------------------------------------------------------
!
    i_field_type = 0
    nb_field     = ds_inout%nb_field
!
! - Find field
!
    do i_field = 1, nb_field
        if (ds_inout%field(i_field)%type .eq. field_type) then
            ASSERT(i_field_type.eq.0)
            i_field_type = i_field
        endif
    end do
    ASSERT(i_field_type.ne.0)
!
! - Set parameters
!
    if (present(l_read_)) then
        ds_inout%l_field_read(i_field_type) = l_read_ 
    endif
    if (present(l_acti_)) then
        ds_inout%l_field_acti(i_field_type) = l_acti_ 
    endif
    if (present(disc_type_)) then
        ds_inout%field(i_field_type)%disc_type = disc_type_
    endif
!
end subroutine
