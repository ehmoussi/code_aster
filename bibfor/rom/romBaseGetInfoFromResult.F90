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
subroutine romBaseGetInfoFromResult(ds_result_in, base, ds_empi)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
#include "asterfort/ltnotb.h"
#include "asterfort/romFieldGetInfo.h"
!
type(ROM_DS_Result), intent(in)  :: ds_result_in
character(len=8), intent(in)     :: base
type(ROM_DS_Empi), intent(inout) :: ds_empi
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Get informations about empiric modes base from input results to reduce
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_result_in     : input results to reduce
! In  base             : name of empiric base
! IO  ds_empi          : datastructure for empiric modes
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iret
    character(len=8) :: model = ' '
    character(len=24) :: field_refe = ' ', field_name = ' '
    character(len=19) :: tabl_coor = ' '
    type(ROM_DS_Field) :: ds_field
!
! --------------------------------------------------------------------------------------------------
!

!
! - Get name of COOR_REDUIT table
!
    call ltnotb(base, 'COOR_REDUIT', tabl_coor, iret)
    ASSERT(iret .ne. 1)
!
! - Get parameters from input results datastructure
!
    field_name = ds_result_in%field_name
    field_refe = ds_result_in%field_refe
    model      = ds_result_in%model
!
! - Get informations from field
!
    ds_field = ds_empi%ds_mode
    call romFieldGetInfo(model, field_name, field_refe, ds_field)
!
! - Save informations about empiric modes
!
    ds_empi%base      = base
    ds_empi%tabl_coor = tabl_coor
    ds_empi%ds_mode   = ds_field
!
end subroutine
