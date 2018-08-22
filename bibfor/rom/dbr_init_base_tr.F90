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
subroutine dbr_init_base_tr(base, ds_para_tr, l_reuse, ds_empi)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/romBaseGetInfo.h"
#include "asterfort/rscrsd.h"
#include "asterfort/romBaseDSCopy.h"
#include "asterfort/dbr_init_prof_tr.h"
!
character(len=8), intent(in) :: base
type(ROM_DS_ParaDBR_TR), intent(inout) :: ds_para_tr
aster_logical, intent(in) :: l_reuse
type(ROM_DS_Empi), intent(inout) :: ds_empi
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Initializations
!
! Prepare datastructure for empiric modes - For POD methods
!
! --------------------------------------------------------------------------------------------------
!
! In  base             : name of empiric base
! IO  ds_para_tr       : datastructure for truncation parameters
! In  l_reuse          : .true. if reuse
! IO  ds_empi          : datastructure for empiric modes
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM2_39')
    endif
!
! - Get informations about empiric base to truncate
!
    if (l_reuse) then
        if (niv .ge. 2) then
            call utmess('I', 'ROM2_56')
        endif
        call romBaseGetInfo(base, ds_empi)
    else
        if (niv .ge. 2) then
            call utmess('I', 'ROM2_57')
        endif
        call romBaseGetInfo(ds_para_tr%base_init, ds_para_tr%ds_empi_init)
    endif
!
! - Create PROF_CHNO for truncation
!
    if (niv .ge. 2) then
        call utmess('I', 'ROM2_55')
    endif
    call dbr_init_prof_tr(base, ds_para_tr)
!
! - Create empiric base (if necessary)
!
    if (.not. l_reuse) then
        if (niv .ge. 2) then
            call utmess('I', 'ROM2_58')
        endif
        call rscrsd('G', base, 'MODE_EMPI', ds_para_tr%ds_empi_init%nb_mode)
        call romBaseDSCopy(ds_para_tr%ds_empi_init, base, ds_empi)
    endif
!
end subroutine
