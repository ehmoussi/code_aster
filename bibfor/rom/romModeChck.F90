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
subroutine romModeChck(ds_mode)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
#include "asterfort/dismoi.h"
#include "asterfort/jelira.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jenuno.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterc/indik8.h"
!
type(ROM_DS_Field), intent(in) :: ds_mode
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Check empiric mode
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_mode          : datastructure for mode
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: mesh, model
    character(len=16) :: modeli
    integer :: nb_dime
!
! --------------------------------------------------------------------------------------------------
!
    mesh       = ds_mode%mesh
    model      = ds_mode%model
!
! - Check mesh
!
    call dismoi('DIM_GEOM', mesh, 'MAILLAGE', repi = nb_dime)
    if (nb_dime .ne. 3) then
        call utmess('F','ROM5_20')
    endif
!
! - Check model
!
    call dismoi('MODELISATION', model, 'MODELE', repk=modeli)
    if (modeli .ne. '3D' .and. modeli .ne. '3D_DIAG' .and. modeli .ne. '3D_SI') then
        call utmess('F','ROM5_20')
    endif
!
end subroutine
