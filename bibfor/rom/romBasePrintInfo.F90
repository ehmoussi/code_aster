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
subroutine romBasePrintInfo(ds_empi)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
#include "asterfort/romModePrintInfo.h"
!
type(ROM_DS_Empi), intent(in) :: ds_empi
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Print informations about empiric modes base
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_empi          : datastructure for empiric modes
!
! --------------------------------------------------------------------------------------------------
!
    call utmess('I', 'ROM7_8')
    if (ds_empi%base_type .eq. 'LINEIQUE') then
        call utmess('I', 'ROM3_10')
        call utmess('I', 'ROM3_11', sk = ds_empi%axe_line)
        call utmess('I', 'ROM3_12', sk = ds_empi%surf_num)
        call utmess('I', 'ROM5_13', si = ds_empi%ds_lineic%nb_slice)
    else
        call utmess('I', 'ROM3_20')
    endif
    if (ds_empi%nb_mode .ne. 0) then
        call utmess('I', 'ROM3_5', si = ds_empi%nb_mode)
    endif
    if (ds_empi%nb_snap .ne. 0) then
        call utmess('I', 'ROM3_9', si = ds_empi%nb_snap)
    endif
    call romModePrintInfo(ds_empi%ds_mode)
!
end subroutine
