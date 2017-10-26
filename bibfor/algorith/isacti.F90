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
subroutine isacti(sddisc, action_type_in, i_action)
!
implicit none
!
#include "asterf_types.h"
#include "event_def.h"
#include "asterfort/utdidt.h"
#include "asterfort/getFailAction.h"
!
character(len=19), intent(in) :: sddisc
integer, intent(in) :: action_type_in
integer, intent(out) :: i_action
!
! ----------------------------------------------------------------------
!
! ROUTINE UTILITAIRE EVENEMENT
!
! DIT SI UN EVENEMENT EST TRAITE
!
! ----------------------------------------------------------------------
!
!
! In  sddisc           : datastructure for time discretization
! In  action_type_in   : action to search
! Out i_action         : index of action
!
! ----------------------------------------------------------------------
!
    integer :: i_fail, nb_fail
    integer :: action_type
!
! ----------------------------------------------------------------------
!
    i_action = 0
    call utdidt('L', sddisc, 'LIST', 'NECHEC', vali_ = nb_fail)
!
    do i_fail = 1, nb_fail
        call getFailAction(sddisc, i_fail, action_type)
        if (action_type .eq. action_type_in) then
            i_action = i_fail
        endif
    end do
!
end subroutine
