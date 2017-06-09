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

subroutine nmetob(ds_inout, field_type, i_field_obsv)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterfort/jeveuo.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(NL_DS_InOut), intent(in) :: ds_inout
    character(len=24), intent(in) :: field_type
    integer, intent(out) :: i_field_obsv
!
! --------------------------------------------------------------------------------------------------
!
! *_NON_LINE - Input/output datastructure
!
! Get index of field used for OBSERVATION
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_inout         : datastructure for input/output management
! In  field_type       : name of field (type) in results datastructure
! Out i_field_obsv     : index of field - 0 if not used for OBSERVATION
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_field, i_field
    character(len=24) :: obsv_keyw
!
! --------------------------------------------------------------------------------------------------
!
    i_field_obsv = 0
    nb_field     = ds_inout%nb_field
!
! - Find field
!
    do i_field = 1, nb_field
        obsv_keyw = ds_inout%field(i_field)%obsv_keyw
        if (obsv_keyw .eq. field_type) then
            i_field_obsv = i_field
        endif
    end do
!
end subroutine
