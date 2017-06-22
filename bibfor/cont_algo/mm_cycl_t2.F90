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

subroutine mm_cycl_t2(pres_frot_prev, dist_frot_prev, coef_frot_prev, cycl_stat_prev, &
                      pres_frot_curr, dist_frot_curr, &
                      coef_frot_curr, cycl_stat_curr)
!
implicit none
!
#include "asterc/r8prem.h"
#include "asterfort/mm_cycl_adaf.h"
#include "asterfort/mm_cycl_laugf.h"
#include "asterfort/mm_cycl_zonf.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    real(kind=8), intent(in) :: pres_frot_prev(3)
    real(kind=8), intent(in) :: dist_frot_prev(3)
    real(kind=8), intent(in) :: coef_frot_prev
    integer, intent(in) :: cycl_stat_prev
    real(kind=8), intent(in) :: pres_frot_curr(3)
    real(kind=8), intent(in) :: dist_frot_curr(3)
    real(kind=8), intent(out) :: coef_frot_curr
    integer, intent(out) :: cycl_stat_curr
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve - Cycling
!
! Treatment: sticking/sliding
!
! --------------------------------------------------------------------------------------------------
!
! In  pres_frot_prev   : previous friction pressure in cycle
! In  dist_frot_prev   : previous friction distance in cycle
! In  coef_frot_prev   : previous augmented ratio for friction
! In  cycl_stat_prev   : previous state of cycle
! In  pres_frot_curr   : current friction pressure
! In  dist_frot_curr   : current friction distance
! Out coef_frot_curr   : current augmented ratio for friction
! Out cycl_stat_curr   : state of treatment
!                      -10 : Failure during adaptation
!                      -02 : Cannot adapt
!                      -01 : has been adapted
!
! --------------------------------------------------------------------------------------------------
!
    integer :: cycl_type, stat_adap
    integer :: zone_frot_curr, zone_frot_prev
    real(kind=8) :: tole_stick, tole_slide
    real(kind=8) :: nrese_curr, nrese_prev, coef_adap
    real(kind=8) :: pres_frot_adap(3), dist_frot_adap(3)
    character(len=8) :: adap_type
!
! --------------------------------------------------------------------------------------------------
!
!
! - Initialisations
!
    cycl_type = 2
    nrese_curr = 0.d0
    nrese_prev = 0.d0
    tole_stick = 0.95
    tole_slide = 1.05
!
! - Default: no adaptation
!
    coef_adap = coef_frot_prev
!
! - Norm of augmented ratios
!
    call mm_cycl_laugf(pres_frot_prev, dist_frot_prev, coef_frot_prev, nrese_prev)
    call mm_cycl_laugf(pres_frot_curr, dist_frot_curr, coef_frot_prev, nrese_curr)
!
! - Previous state
!
    if (cycl_stat_prev .eq. -1) goto 99
!
! - Which is near-sliding/near-sticking ?
!
    call mm_cycl_zonf(nrese_curr, tole_stick, tole_slide, zone_frot_curr)
    call mm_cycl_zonf(nrese_prev, tole_stick, tole_slide, zone_frot_prev)
    if (zone_frot_curr.eq.-1) then
        pres_frot_adap(1) = pres_frot_curr(1)
        pres_frot_adap(2) = pres_frot_curr(2)
        pres_frot_adap(3) = pres_frot_curr(3)
        dist_frot_adap(1) = dist_frot_curr(1)
        dist_frot_adap(2) = dist_frot_curr(2)
        dist_frot_adap(3) = dist_frot_curr(3)
        adap_type = 'Sticking'
    elseif (zone_frot_curr.eq.+1) then
        pres_frot_adap(1) = pres_frot_curr(1)
        pres_frot_adap(2) = pres_frot_curr(2)
        pres_frot_adap(3) = pres_frot_curr(3)
        dist_frot_adap(1) = dist_frot_curr(1)
        dist_frot_adap(2) = dist_frot_curr(2)
        dist_frot_adap(3) = dist_frot_curr(3)
        adap_type = 'Sliding'
    elseif (zone_frot_prev.eq.-1) then
        pres_frot_adap(1) = pres_frot_prev(1)
        pres_frot_adap(2) = pres_frot_prev(2)
        pres_frot_adap(3) = pres_frot_prev(3)
        dist_frot_adap(1) = dist_frot_prev(1)
        dist_frot_adap(2) = dist_frot_prev(2)
        dist_frot_adap(3) = dist_frot_prev(3)
        adap_type = 'Sticking'
    elseif (zone_frot_prev.eq.+1) then
        pres_frot_adap(1) = pres_frot_prev(1)
        pres_frot_adap(2) = pres_frot_prev(2)
        pres_frot_adap(3) = pres_frot_prev(3)
        dist_frot_adap(1) = dist_frot_prev(1)
        dist_frot_adap(2) = dist_frot_prev(2)
        dist_frot_adap(3) = dist_frot_prev(3)
        adap_type = 'Sliding'
    else
       cycl_stat_curr = -2
       goto 99
    endif
!
! - Trying to adapt coef
!
    call mm_cycl_adaf(adap_type, tole_stick, tole_slide, coef_frot_prev, pres_frot_adap, &
                      dist_frot_adap, coef_adap, stat_adap)
    if (stat_adap.eq.0) then
        cycl_stat_curr = -1
    elseif (stat_adap.eq.-1) then
        cycl_stat_curr = -10
    endif

99  continue
!
! - New augmented ratio
!
    coef_frot_curr = coef_adap

end subroutine
