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
subroutine iseven(sddisc, event_type_in, lacti)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/utdidt.h"
#include "asterfort/getFailEvent.h"
!
character(len=19), intent(in) :: sddisc
integer, intent(in) :: event_type_in
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
    integer :: i_fail, nb_fail
    integer :: event_type
!
! ----------------------------------------------------------------------
!
    lacti = .false.
    call utdidt('L', sddisc, 'LIST', 'NECHEC', vali_ = nb_fail)
!
    do i_fail = 1, nb_fail
        call getFailEvent(sddisc, i_fail, event_type)
        if (event_type_in .eq. event_type_in) then
            lacti = .true.
        endif
    end do
!
end subroutine
