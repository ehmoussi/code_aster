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
subroutine dbr_init_base_pod(baseName, paraPod, lReuse, base)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/dbr_rnum.h"
#include "asterfort/infniv.h"
#include "asterfort/modelNodeEF.h"
#include "asterfort/nonlinDSTableIOCreate.h"
#include "asterfort/romBaseCreate.h"
#include "asterfort/romBaseGetInfo.h"
#include "asterfort/romTableCreate.h"
#include "asterfort/utmess.h"
!
character(len=8), intent(in) :: baseName
type(ROM_DS_ParaDBR_POD), intent(inout) :: paraPod
aster_logical, intent(in) :: lReuse
type(ROM_DS_Empi), intent(inout) :: base
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Initializations
!
! Prepare datastructure for modes - For POD methods
!
! --------------------------------------------------------------------------------------------------
!
! In  baseName         : name of base
! IO  paraPod          : datastructure for parameters (POD)
! In  lReuse           : .true. if reuse
! IO  base             : base
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nbNodeWithDof
    character(len=8) :: model
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM2_12')
    endif
!
! - Create base
!
    if (.not. lReuse) then
        base%base = baseName
        call romBaseCreate(base, paraPod%nb_mode_maxi)
    endif
!
! - Create datastructure of table in results datastructure for the reduced coordinates
!
    call romTableCreate(baseName, paraPod%tablReduCoor%tablResu)
!
! - Create table in results datastructure (if necessary)
!
    call nonlinDSTableIOCreate(paraPod%tablReduCoor%tablResu)
!
! - Get informations about base
!
    if (lReuse) then
        call romBaseGetInfo(baseName, base)
    else
        base%base      = baseName
        base%ds_mode   = paraPod%resultDom%field
        base%base_type = paraPod%base_type
        base%axe_line  = paraPod%axe_line
        base%surf_num  = paraPod%surf_num
        base%nb_mode   = 0
        base%nb_snap   = 0
    endif
!
! - Create numbering of nodes for the lineic model
!
    if (base%base_type .eq. 'LINEIQUE') then
        if (niv .ge. 2) then
            call utmess('I', 'ROM2_40')
        endif
        model = base%ds_mode%model
        call modelNodeEF(model, nbNodeWithDof)
        call dbr_rnum(base, nbNodeWithDof)
    endif
!
end subroutine
