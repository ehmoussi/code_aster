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

subroutine romBaseInfo(ds_empi)
!
use Rom_Datastructure_type
!
implicit none
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(ROM_DS_Empi), intent(in) :: ds_empi
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Informations about empiric modes base
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_empi          : datastructure for empiric modes
!
! --------------------------------------------------------------------------------------------------
!
    call utmess('I', 'ROM7_8')
    call utmess('I', 'ROM3_1', sk = ds_empi%base)
    call utmess('I', 'ROM3_2', sk = ds_empi%model)
    call utmess('I', 'ROM3_3', sk = ds_empi%mesh)
    call utmess('I', 'ROM3_4', sk = ds_empi%field_name)
    if (ds_empi%base_type .eq. 'LINEIC') then
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
    call utmess('I', 'ROM3_6', si = ds_empi%nb_node)
    call utmess('I', 'ROM3_7', si = ds_empi%nb_equa)
    call utmess('I', 'ROM3_8', si = ds_empi%nb_cmp)
    if (ds_empi%nb_snap .ne. 0) then
        call utmess('I', 'ROM3_9', si = ds_empi%nb_snap)
    endif
!
end subroutine
