! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
subroutine dbr_para_info(cmdPara)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/dbr_para_info_pod.h"
#include "asterfort/dbr_para_info_rb.h"
#include "asterfort/dbr_para_info_tr.h"
#include "asterfort/dbr_para_info_ortho.h"
!
type(ROM_DS_ParaDBR), intent(in) :: cmdPara
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Initializations
!
! Informations about DEFI_BASE_REDUITE parameters
!
! --------------------------------------------------------------------------------------------------
!
! In  cmdPara          : datastructure for parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=16) :: operation
    aster_logical :: lReuse
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
!
! - Get parameters in datastructure - General for DBR
!
    operation     = cmdPara%operation
    lReuse        = cmdPara%lReuse
!
! - Print - General for DBR
!
    if (niv .ge. 2) then
        call utmess('I', 'ROM5_24')
        call utmess('I', 'ROM5_16', sk = operation)
        if (lReuse) then
            call utmess('I', 'ROM7_15')
        else
            call utmess('I', 'ROM7_16')
        endif
    endif
!
! - Print / method
!
    if (operation(1:3) .eq. 'POD') then
        call dbr_para_info_pod(operation, cmdPara%paraPod)

    elseif (operation .eq. 'GLOUTON') then
        call dbr_para_info_rb(cmdPara%paraRb)

    elseif (operation .eq. 'TRONCATURE') then
        call dbr_para_info_tr(cmdPara%paraTrunc)

    elseif (operation .eq. 'ORTHO') then
        call dbr_para_info_ortho(cmdPara%paraOrtho)

    else
        ASSERT(ASTER_FALSE)
    endif
!
end subroutine
