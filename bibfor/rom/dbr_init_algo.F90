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
subroutine dbr_init_algo(ds_para)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/dbr_init_algo_pod.h"
#include "asterfort/dbr_init_algo_rb.h"
#include "asterfort/dbr_init_algo_tr.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
!
type(ROM_DS_ParaDBR), intent(inout) :: ds_para
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Initializations
!
! Init algorithm
!
! --------------------------------------------------------------------------------------------------
!
! IO  ds_para          : datastructure for parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM7_6')
    endif
!
    if (ds_para%operation(1:3) .eq. 'POD') then
        call dbr_init_algo_pod(ds_para%result_out, ds_para%ds_empi,&
                               ds_para%para_pod%tabl_name)
    elseif (ds_para%operation .eq. 'GLOUTON') then
        call dbr_init_algo_rb(ds_para%para_rb)
    elseif (ds_para%operation .eq. 'TRONCATURE') then
        call dbr_init_algo_tr(ds_para%para_tr)
    else
        ASSERT(.false.)
    endif
!
end subroutine
