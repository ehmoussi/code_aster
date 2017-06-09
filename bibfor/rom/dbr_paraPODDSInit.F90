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

subroutine dbr_paraPODDSInit(ds_snap, ds_para_pod)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/r8vide.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
!
! person_in_charge: mickael.abbas at edf.fr
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
    integer :: ifm, niv
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM5_25')
    endif
!
! - General initialisations of datastructure
!
    ds_para_pod%result_in    = ' '
    ds_para_pod%field_name   = ' '
    ds_para_pod%base_type    = ' '
    ds_para_pod%axe_line     = ' '
    ds_para_pod%surf_num     = ' '
    ds_para_pod%tole_svd     = r8vide()
    ds_para_pod%tole_incr    = r8vide()
    ds_para_pod%ds_snap      = ds_snap
    ds_para_pod%tabl_name    = ' '
!
end subroutine
