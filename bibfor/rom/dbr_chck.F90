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
subroutine dbr_chck(ds_para)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/dbr_chck_pod.h"
#include "asterfort/dbr_chck_rb.h"
#include "asterfort/dbr_chck_tr.h"
!
type(ROM_DS_ParaDBR), intent(in) :: ds_para
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Initializations
!
! Some checks
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_para          : datastructure for parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM7_7')
    endif
!
    if (ds_para%operation(1:3) .eq. 'POD') then
        call dbr_chck_pod(ds_para%operation, ds_para%para_pod, ds_para%l_reuse)
    elseif (ds_para%operation .eq. 'GLOUTON') then
        call dbr_chck_rb(ds_para%operation, ds_para%para_rb, ds_para%l_reuse)
    elseif (ds_para%operation .eq. 'TRONCATURE') then
        call dbr_chck_tr(ds_para%para_tr, ds_para%l_reuse)
    else
        ASSERT(.false.)
    endif
!
end subroutine
