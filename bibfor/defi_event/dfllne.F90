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
!
subroutine dfllne(keywf, nb_fail, l_fail_error)
!
implicit none
!
#include "asterf_types.h"
#include "event_def.h"
#include "asterc/getfac.h"
#include "asterfort/assert.h"
#include "asterfort/getvtx.h"
#include "asterfort/utmess.h"
!
character(len=16), intent(in) :: keywf
integer, intent(out) :: nb_fail
aster_logical, intent(out) :: l_fail_error
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_LIST_INST - Read parameters
!
! Get number of failure keywords
!
! --------------------------------------------------------------------------------------------------
!
! In  keywf            : factor keyword to read failures
! Out nb_fail          : number of failures defined in command file
! Out l_fail_error     : .true. if ERREUR fail is defined
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_fail_read, i_event, i_event_acti
    character(len=16) :: event_typek
    integer :: nb_evt_count(FAIL_EVT_NB)
!
! --------------------------------------------------------------------------------------------------
!
    l_fail_error    = .false._1
    nb_fail         = 0
    nb_evt_count(:) = 0
!
! - Number of ECHEC keywords
!
    call getfac(keywf, nb_fail)
!
! - Count number of events
!
    do i_fail_read = 1, nb_fail
        call getvtx(keywf, 'EVENEMENT', iocc=i_fail_read, scal=event_typek)
        i_event_acti = 0
        do i_event = 1, FAIL_EVT_NB
            if (event_typek .eq. failEventKeyword(i_event)) then
                i_event_acti = i_event
            endif
        end do
        ASSERT(i_event_acti .gt. 0)
        nb_evt_count(i_event_acti) = nb_evt_count(i_event_acti) + 1
    end do
!
! - Check number of events
!
    do i_event = 1, FAIL_EVT_NB
        event_typek = failEventKeyword(i_event)
        if (nb_evt_count(i_event) .gt. failEventMaxi(i_event)) then
            call utmess('F', 'DISCRETISATION_10', sk = event_typek)
        endif
    end do
!
! - Special for ERROR failure
!
    l_fail_error = nb_evt_count(FAIL_EVT_ERROR) .eq. 1
!
end subroutine
