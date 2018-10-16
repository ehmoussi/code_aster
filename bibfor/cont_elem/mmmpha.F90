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
subroutine mmmpha(loptf , lpenac, lpenaf,&
                  lcont , ladhe , &
                  phasep)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
!
aster_logical, intent(in) :: loptf, lpenaf, lpenac
aster_logical, intent(in) :: lcont, ladhe
character(len=9), intent(out) :: phasep
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Select phase to compute
!
! --------------------------------------------------------------------------------------------------
!
! In  loptf            : flag if compute RIGI_FROT
! In  lcont            : .true. if contact
! In  ladhe            : .true. if stick
! In  lpenac           : flag for penalized contact
! In  lpenaf           : flag for penalized friction
! Out phasep           : 'SANS' - No contact
!                        'CONT' - Contact
!                        'ADHE' - Stick
!                        'GLIS' - Slip
!                        'SANS_PENA' - PENALISATION - No contact
!                        'CONT_PENA' - PENALISATION - Contact
!                        'ADHE_PENA' - PENALISATION - Stick
!                        'GLIS_PENA' - PENALISATION - Slip
!
! --------------------------------------------------------------------------------------------------
!
    character(len=4) :: phase
!
! --------------------------------------------------------------------------------------------------
!
    phase  = ' '
    phasep = ' '
!
! - Main phase
!
    if (loptf) then
        if (lcont) then
            if (ladhe) then
                phase = 'ADHE'
            else
                phase = 'GLIS'
            endif
        else
            phase = 'SANS'
        endif
    else
        if (lcont) then
            phase = 'CONT'
        else
            phase = 'SANS'
        endif
    endif
!
! - Phase for penalization
!
    if (phase .eq. 'SANS') then
        if (lpenac .or. lpenaf) then
            phasep = phase(1:4)//'_PENA'
        else
            phasep = phase(1:4)
        endif
    else if (phase.eq.'CONT') then
        if (lpenac) then
            phasep = phase(1:4)//'_PENA'
        else
            phasep = phase(1:4)
        endif
    else if ((phase.eq.'ADHE').or.(phase.eq.'GLIS')) then
        if (lpenaf) then
            phasep = phase(1:4)//'_PENA'
        else
            phasep = phase(1:4)
        endif
    else
        ASSERT(ASTER_FALSE)
    endif
!
end subroutine
