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
subroutine dbr_para_info(ds_para)
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
#include "asterfort/romBasePrintInfo.h"
!
type(ROM_DS_ParaDBR), intent(in) :: ds_para
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Initializations
!
! Informations about DEFI_BASE_REDUITE parameters
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_para          : datastructure for parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=16) :: operation = ' '
    character(len=8)  :: result_out = ' '
    aster_logical :: l_reuse, l_base
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
!
! - Get parameters in datastructure - General for DBR
!
    operation    = ds_para%operation
    result_out   = ds_para%result_out
    l_reuse      = ds_para%l_reuse
    l_base       = ds_para%l_base
!
! - Print - General for DBR
!
    if (niv .ge. 2) then
        call utmess('I', 'ROM5_24')
        call utmess('I', 'ROM5_16', sk = operation)
        if (l_reuse) then
            call utmess('I', 'ROM7_15')
        else
            call utmess('I', 'ROM7_16')
        endif
    endif
!
! - Print about empiric base
!
    if (niv .ge. 2) then
        if (l_base) then
            call romBasePrintInfo(ds_para%ds_empi)
        endif
    endif
!
! - Print / method
!
    if (operation(1:3) .eq. 'POD') then
        call dbr_para_info_pod(ds_para%para_pod)
        
    elseif (operation .eq. 'GLOUTON') then
        call dbr_para_info_rb(ds_para%para_rb)

    elseif (operation .eq. 'TRONCATURE') then
        call dbr_para_info_tr(ds_para%para_tr)

    else
        ASSERT(.false.)
    endif
!
end subroutine
