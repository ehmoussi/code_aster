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

subroutine mm_cycl_zonf(lagr_frot_norm, tole_stick, tole_slide, zone_frot)
!
implicit none
!
#include "asterc/r8prem.h"
#include "asterfort/assert.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    real(kind=8), intent(in) :: lagr_frot_norm
    real(kind=8), intent(in) :: tole_stick
    real(kind=8), intent(in) :: tole_slide
    integer, intent(out) :: zone_frot
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve - Cycling
!
! Detection of zone for friction
!
! --------------------------------------------------------------------------------------------------
!
! In  lagr_frot_norm   : norm of augmented lagrangian for friction
! In  tole_stick       : tolerance for "near" discontinuity point by inferior value (sticking)
! In  tole_slide       : tolerance for "near" discontinuity point by superior value (sliding)
! Out zone_frot        : zone of friction
!                       -2 - Sticking far from discontinuity point
!                       -1 - Sticking near discontinuity point
!                        0 - Near discontinuity point
!                       +1 - Sliding near discontinuity point
!                       +2 - Sliding far from discontinuity point
!
! --------------------------------------------------------------------------------------------------
!
    if (lagr_frot_norm.lt.tole_stick) then
        zone_frot = -2
    elseif ((lagr_frot_norm.ge.tole_stick).and.(lagr_frot_norm.le.1.d0)) then
        zone_frot = -1
    elseif ((lagr_frot_norm.gt.tole_stick).and.(lagr_frot_norm.lt.tole_slide)) then
        zone_frot = 0
    elseif ((lagr_frot_norm.ge.1.d0).and.(lagr_frot_norm.le.tole_slide)) then
        zone_frot = +1
    elseif (lagr_frot_norm.gt.tole_slide) then
        zone_frot = +2
    else
        ASSERT(.false.)
    endif

end subroutine
