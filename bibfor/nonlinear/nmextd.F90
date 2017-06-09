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

subroutine nmextd(field_type, ds_inout, field_algo)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterfort/nmetnc.h"
#include "asterfort/nmetob.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=*), intent(in) :: field_type
    type(NL_DS_InOut), intent(in) :: ds_inout
    character(len=*), intent(out) :: field_algo
!
! --------------------------------------------------------------------------------------------------
!
! *_NON_LINE - Extraction (OBSERVATION/SUIVI_DDL) utilities 
!
! Get field
!
! --------------------------------------------------------------------------------------------------
!
! In  field_type       : name of field (type) in results datastructure
! In  ds_inout         : datastructure for input/output management
! Out field_algo       : name of datastructure for field
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: algo_name
    integer :: i_field_obsv
!
! --------------------------------------------------------------------------------------------------
!
!
! - Get index of field used for OBSERVATION
!
    call nmetob(ds_inout, field_type, i_field_obsv)
!
! - Get name of datastructure for field
!
    if (i_field_obsv.ne.0) then
        algo_name  = ds_inout%field(i_field_obsv)%algo_name
        call nmetnc(algo_name, field_algo)
    endif
!
end subroutine
