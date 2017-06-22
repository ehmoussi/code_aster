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

subroutine ndxcfl(mate, cara_elem, sddyna, sddisc)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/getvid.h"
#include "asterfort/ndynlo.h"
#include "asterfort/pascom.h"
#include "asterfort/pascou.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=19), intent(in) :: sddisc
    character(len=19), intent(in) :: sddyna
    character(len=24), intent(in) :: cara_elem
    character(len=24), intent(in) :: mate
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Datastructures
!
! CFL condition for explicit dynamic
!
! --------------------------------------------------------------------------------------------------
!
! In  mate             : name of material characteristics (field)
! In  cara_elem        : name of elementary characteristics (field)
! In  sddyna           : name of dynamic parameters
! In  sddisc           : datastructure for time discretization
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: l_proj_modal
    character(len=8) :: mode_meca
!
! --------------------------------------------------------------------------------------------------
!
!
! - Active functionnalities
!
    l_proj_modal = ndynlo(sddyna,'PROJ_MODAL')
!
! - Compute CFL condition
!
    if (l_proj_modal) then
        call getvid('PROJ_MODAL', 'MODE_MECA', iocc=1, scal=mode_meca)
        call pascom(mode_meca, sddyna, sddisc)
    else
        call pascou(mate, cara_elem, sddyna, sddisc)
    endif
!
end subroutine
