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

subroutine dbr_init_algo_pod(base, ds_empi, tabl_name)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/dbr_rnum.h"
#include "asterfort/romTableCreate.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: base
    type(ROM_DS_Empi), intent(inout) :: ds_empi
    character(len=19), intent(out) :: tabl_name
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Initializations
!
! Init algorithm for POD
!
! --------------------------------------------------------------------------------------------------
!
! In  base             : name of empiric base
! IO  ds_empi          : datastructure for empiric modes
! Out tabl_name        : name of table in results datastructure
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM2_40')
    endif
!
! - Create numbering of nodes for the lineic model
!
    if (ds_empi%base_type .eq. 'LINEIQUE') then
        call dbr_rnum(ds_empi)
    endif
!
! - Create table for the reduced coordinates in results datatructure
!
    call romTableCreate(base, tabl_name)
!
end subroutine
