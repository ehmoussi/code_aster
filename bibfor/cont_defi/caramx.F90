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

subroutine caramx(sdcont, cont_form, nb_cont_zone)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/caracc.h"
#include "asterfort/caracd.h"
#include "asterfort/caracm.h"
#include "asterfort/caracp.h"
#include "asterfort/caracx.h"
!
! person_in_charge: ayaovi-dzifa.kudawoo at edf.fr
!
    character(len=8), intent(in) :: sdcont
    integer, intent(in) :: cont_form
    integer, intent(in) :: nb_cont_zone
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_CONTACT
!
! Creation of datastructures
!
! --------------------------------------------------------------------------------------------------
!
! In  sdcont           : name of contact concept (DEFI_CONTACT)
! In  cont_form        : formulation of contact
! In  nb_cont_zone     : number of zones of contact
!
! --------------------------------------------------------------------------------------------------
!
!
! - Datastructures for all formulations (Not depending on contact zone)
!
    call caracp(sdcont)
!
! - Datastructures for formulations
!
    if (cont_form .eq. 1) then
        call caracm(sdcont, nb_cont_zone)
        call caracd(sdcont, nb_cont_zone)
    else if (cont_form .eq. 2) then
        call caracm(sdcont, nb_cont_zone)
        call caracc(sdcont, nb_cont_zone)
    else if (cont_form .eq. 3) then
        call caracx(sdcont, nb_cont_zone)
    else if (cont_form .eq. 5) then
        call caracm(sdcont, nb_cont_zone)
        call caracc(sdcont, nb_cont_zone)
    else
        ASSERT(.false.)
    endif
!
end subroutine
