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

subroutine mm_cycl_zonc(pres_near, laug_cont, zone_cont)
!
implicit none
!
#include "asterc/r8prem.h"
#include "asterfort/assert.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    real(kind=8), intent(in) :: laug_cont
    real(kind=8), intent(in) :: pres_near
    integer, intent(out) :: zone_cont
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve - Cycling
!
! Detection of zone for contact
!
! --------------------------------------------------------------------------------------------------
!
! In  laug_cont        : augmented lagrangian for contact
! In  pres_near        : tolerance for "near" contact - pressure
! Out zone_cont        : zone of contact
!
! --------------------------------------------------------------------------------------------------
!
    if (laug_cont.gt.pres_near) then
        zone_cont = 1
    elseif ((laug_cont.le.pres_near).and.(laug_cont.ge.r8prem())) then
        zone_cont = 2
    elseif ((laug_cont.ge.-pres_near).and.(laug_cont.le.r8prem())) then
        zone_cont = 3
    elseif (laug_cont.lt.-pres_near) then
        zone_cont = 4
    else
        ASSERT(.false.)
    endif

end subroutine
