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

subroutine romBaseDSInit(ds_lineicnumb, ds_empi)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(ROM_DS_LineicNumb), intent(in) :: ds_lineicnumb
    type(ROM_DS_Empi), intent(out) :: ds_empi
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Initializations
!
! Initialization of datastructure for empiric modes
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_lineicnumb    : datastructure for lineic base numbering
! Out ds_empi          : datastructure for empiric modes
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM2_3')
    endif
!
! - Create parameters datastructure
!
    ds_empi%base         = ' '
    ds_empi%field_name   = ' '
    ds_empi%field_refe   = ' '
    ds_empi%mesh         = ' '
    ds_empi%model        = ' '
    ds_empi%base_type    = ' '
    ds_empi%axe_line     = ' '
    ds_empi%surf_num     = ' '
    ds_empi%nb_node      = 0
    ds_empi%nb_mode      = 0
    ds_empi%nb_snap      = 0
    ds_empi%nb_equa      = 0
    ds_empi%nb_cmp       = 0
    ds_empi%ds_lineic    = ds_lineicnumb
!
end subroutine
