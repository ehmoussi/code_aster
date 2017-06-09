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

subroutine dieven(sddisc, i_event, lacti)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/utdidt.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=19), intent(in) :: sddisc
    integer, intent(in) :: i_event
    aster_logical :: lacti
!
! --------------------------------------------------------------------------------------------------
!
! ROUTINE UTILITAIRE EVENEMENT
!
! RETOURNE LA VALEUR D'UN EVENEMENT
!
! --------------------------------------------------------------------------------------------------
!
! In  sddisc           : datastructure for time discretization
! IN  IEVENT           : INDICE DE L'EVENEMENT ACTIVE
! OUT LACTI            : .TRUE. SI ACTIVE
!                        .FALSE. SI DESACTIVE
!
! --------------------------------------------------------------------------------------------------
!
    character(len=16) :: active
!
! --------------------------------------------------------------------------------------------------
!
    if (i_event .ne. 0) then
        call utdidt('L', sddisc, 'ECHE', 'VERIF_EVEN', index_ = i_event,&
                    valk_ = active)
        if (active .eq. 'OUI') then
            lacti = .true.
        else if (active.eq.'NON') then
            lacti = .false.
        else
            write(6,*) 'DIEVEN: ',i_event,active
            ASSERT(.false.)
        endif
    endif
!
end subroutine
