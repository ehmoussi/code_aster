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

subroutine iseven(sddisc, event_name_s_, lacti)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/utdidt.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=19), intent(in) :: sddisc
    character(len=*), intent(in) :: event_name_s_
    aster_logical :: lacti
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
! IN  event_name_s     : EVENEMENT A CHERCHER
! OUT LACTI  : .TRUE. SI TRAITE
!              .FALSE. SINON
!
! ----------------------------------------------------------------------
!
    integer :: i_event, nb_event
    character(len=16) :: event_name, event_name_s
!
! ----------------------------------------------------------------------
!
    lacti = .false.
    event_name_s = event_name_s_
    call utdidt('L', sddisc, 'LIST', 'NECHEC',&
                vali_ = nb_event)
!
    do i_event = 1, nb_event
        call utdidt('L', sddisc, 'ECHE', 'NOM_EVEN', index_ = i_event,&
                    valk_ = event_name)
        if (event_name .eq. event_name_s) then
            lacti = .true.
        endif
    end do
!
end subroutine
