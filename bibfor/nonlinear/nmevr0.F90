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
subroutine nmevr0(sddisc)
!
implicit none
!
#include "asterf_types.h"
#include "event_def.h"
#include "asterfort/dieven.h"
#include "asterfort/nmlerr.h"
#include "asterfort/utdidt.h"
#include "asterfort/getFailAction.h"
!
character(len=19) :: sddisc
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME - EVENEMENTS)
!
! REINITIALISATIONS DES EVENEMENTS
!
! ----------------------------------------------------------------------
!
!
! In  sddisc           : datastructure for time discretization TEMPORELLE
!
!
!
!
    integer :: itesup, i_fail, nb_fail, action_type
    real(kind=8) :: r8bid
    aster_logical :: lacti
!
! ----------------------------------------------------------------------
!
    call utdidt('L', sddisc, 'LIST', 'NECHEC', vali_ = nb_fail)
!
! --- DESACTIVATION DES EVENEMENTS
!
    do i_fail = 1, nb_fail
        lacti = .false.
        call dieven(sddisc, i_fail, lacti)
        call getFailAction(sddisc, i_fail, action_type)
        if (action_type .eq. FAIL_ACT_ITER) then
            itesup = 0
            call nmlerr(sddisc, 'E', 'ITERSUP', r8bid, itesup)
        endif
    end do
!
end subroutine
