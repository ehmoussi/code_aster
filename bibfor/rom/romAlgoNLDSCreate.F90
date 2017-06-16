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
subroutine romAlgoNLDSCreate(ds_algorom)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/infniv.h"
#include "asterfort/romBaseDSInit.h"
#include "asterfort/romLineicBaseDSInit.h"
#include "asterfort/utmess.h"
!
type(ROM_DS_AlgoPara), intent(out) :: ds_algorom
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Solving non-linear problem
!
! Create ROM parameters datastructure
!
! --------------------------------------------------------------------------------------------------
!
! Out ds_algorom       : datastructure for ROM parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    type(ROM_DS_LineicNumb) :: ds_lineicnumb
    type(ROM_DS_Empi) :: ds_empi
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM5_36')
    endif
!
! - Initialization of datastructure for lineic base numbering
!
    call romLineicBaseDSInit(ds_lineicnumb)
!
! - Initialization of datastructure for empiric modes
!
    call romBaseDSInit(ds_lineicnumb, ds_empi)   
!
! - General parameters
!
    ds_algorom%l_rom         = .false._1
    ds_algorom%ds_empi       = ds_empi
    ds_algorom%l_hrom        = .false._1
    ds_algorom%l_hrom_corref = .false._1
    ds_algorom%grnode_int    = ' '
    ds_algorom%grnode_sub    = ' '
    ds_algorom%tabl_name     = ' '
    ds_algorom%gamma         = ' '
    ds_algorom%phase         = ' '
    ds_algorom%v_equa_int    => null()
    ds_algorom%v_equa_sub    => null()
    ds_algorom%field_iden    = ' '
    ds_algorom%vale_pena     = 0.d0
!
end subroutine
