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
! aslint: disable=W1403
!
subroutine dbr_paraPODDSInit(ds_snap, ds_para_pod)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/r8vide.h"
!
type(ROM_DS_Snap), intent(in) :: ds_snap
type(ROM_DS_ParaDBR_POD), intent(out) :: ds_para_pod
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Initializations
!
! Initialization of datastructures for parameters - POD methods
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_snap          : datastructure for snapshot selection
! Out ds_para_pod      : datastructure for POD parameters
!
! --------------------------------------------------------------------------------------------------
!
    ds_para_pod%field_name   = ' '
    ds_para_pod%model_user   = ' '
    ds_para_pod%base_type    = ' '
    ds_para_pod%axe_line     = ' '
    ds_para_pod%surf_num     = ' '
    ds_para_pod%tole_svd     = r8vide()
    ds_para_pod%tole_incr    = r8vide()
    ds_para_pod%l_tabl_user  = ASTER_FALSE
    ds_para_pod%tabl_user    = ' '
    ds_para_pod%nb_mode_maxi = 0
    ds_para_pod%ds_snap      = ds_snap
!
end subroutine
