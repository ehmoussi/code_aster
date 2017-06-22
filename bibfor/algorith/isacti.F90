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

subroutine isacti(sddisc, action_name_s_, i_action)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/utdidt.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=19), intent(in) :: sddisc
    character(len=*), intent(in) :: action_name_s_
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
! In  action_name_s    : action to search
! Out i_action         : index of action
!
! ----------------------------------------------------------------------
!
    integer :: i_echec, nb_echec
    character(len=16) :: action_name_s, action_name
!
! ----------------------------------------------------------------------
!
    i_action = 0
    action_name_s = action_name_s_
    call utdidt('L', sddisc, 'LIST', 'NECHEC',&
                vali_ = nb_echec)
!
    do i_echec = 1, nb_echec
        call utdidt('L', sddisc, 'ECHE', 'ACTION', index_ = i_echec,&
                    valk_ = action_name)
        if (action_name .eq. action_name_s) then
            i_action = i_echec
        endif
    end do
!
end subroutine
