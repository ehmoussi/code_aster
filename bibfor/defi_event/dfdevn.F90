! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
subroutine dfdevn(action_typek, subd_method, subd_pas_mini, subd_pas, subd_niveau)
!
implicit none
!
#include "event_def.h"
!
character(len=16), intent(out) :: action_typek
character(len=16), intent(out) :: subd_method
real(kind=8), intent(out) :: subd_pas_mini
integer, intent(out) :: subd_pas, subd_niveau
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_LIST_INST - Read parameters
!
! Default values for cuttin time step
!
! --------------------------------------------------------------------------------------------------
!
! Out action_typek     : type of action
! Out subd_method      : value of SUBD_METHODE for ACTION=DECOUPE
! Out subd_pas_mini    : value of SUBD_PAS_MINI for ACTION=DECOUPE
! Out subd_niveau      : value of SUBD_NIVEAU for ACTION=DECOUPE
! Out subd_pas         : value of SUBD_PAS for ACTION=DECOUPE
!
! --------------------------------------------------------------------------------------------------
!
    action_typek  = failActionKeyword(FAIL_ACT_CUT)
    subd_method   = 'MANUEL'
    subd_niveau   = 3
    subd_pas      = 4
    subd_pas_mini = 1.d-12
!
end subroutine
