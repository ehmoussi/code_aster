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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine dbr_read(ds_para)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/getres.h"
#include "asterc/gcucon.h"
#include "asterfort/assert.h"
#include "asterfort/dbr_read_pod.h"
#include "asterfort/dbr_read_rb.h"
#include "asterfort/getvtx.h"
#include "asterfort/getvr8.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
!
type(ROM_DS_ParaDBR), intent(inout) :: ds_para
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Initializations
!
! Read parameters
!
! --------------------------------------------------------------------------------------------------
!
! IO  ds_para          : datastructure for parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=16) :: k16bid, operation = ' '
    character(len=8) :: result_out = ' '
    integer :: ireuse
    aster_logical :: l_reuse
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM5_10')
    endif
!
! - Output datastructure
!
    call getres(result_out, k16bid, k16bid)
!
! - Is REUSE?
!
    call gcucon(result_out, 'MODE_EMPI', ireuse)
    l_reuse = ireuse .ne. 0
!
! - Type of ROM methods
!
    call getvtx(' ', 'OPERATION', scal = operation)
    if (operation(1:3) .eq. 'POD') then
        call dbr_read_pod(operation, ds_para%para_pod)
    elseif (operation .eq. 'GLOUTON') then
        call dbr_read_rb(ds_para%para_rb)
    else
        ASSERT(.false.)
    endif
!
! - Save parameters in datastructure
!
    ds_para%operation    = operation
    ds_para%result_out   = result_out
    ds_para%l_reuse      = l_reuse
!
end subroutine
