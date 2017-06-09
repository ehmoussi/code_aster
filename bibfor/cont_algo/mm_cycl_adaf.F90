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

subroutine mm_cycl_adaf(adap_type, tole_stick, tole_slide, coef_init, pres_frot,&
                        dist_frot, coef_adap, stat_adap)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/mm_cycl_laugf.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: adap_type
    real(kind=8), intent(in) :: tole_stick
    real(kind=8), intent(in) :: tole_slide
    real(kind=8), intent(in) :: coef_init
    real(kind=8), intent(in) :: pres_frot(3)
    real(kind=8), intent(in) :: dist_frot(3)
    real(kind=8), intent(out) :: coef_adap
    integer, intent(out) :: stat_adap
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve - Cycling
!
! Adaptation of augmented ratio for friction
!
! --------------------------------------------------------------------------------------------------
!
! In  adap_type : type of adaptation
!                 'Sticking' - Too near from discontinuity point. Try to transform in sticking mode
!                 'Sliding' - Too near from discontinuity point. Try to transform in sliding mode
! In  tole_stick : tolerance for "near" discontinuity point by inferior value (sticking)
! In  tole_slide : tolerance for "near" discontinuity point by superior value (sliding)
! In  coef_init  : initial augmented ratio for friction
! In  pres_frot  : friction pressure
! In  dist_frot  : friction distance
! Out coef_adap  : augmented ratio for friction after adaptation
! Out stat_adap  : results of adaptation
!                       0 : OK
!                      -1 : NOOK
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: nrese, new_coef
    integer :: icoef
    aster_logical :: l_augm, l_stop
!
! --------------------------------------------------------------------------------------------------
!
!
! - Initialisations
!
    stat_adap = -1
    l_augm = .true.
    l_stop = .false.
!
! - Trying to adapt coef
!
 10 continue
    new_coef = coef_init
    do icoef = 1, 30
        call mm_cycl_laugf(pres_frot, dist_frot, new_coef, nrese)
!
        if (adap_type .eq. 'Sticking') then
            if (nrese .le. tole_stick) then
                stat_adap = 0
                goto 99
            endif
        endif
!
        if (adap_type .eq. 'Sliding') then
            if (nrese .ge. tole_slide) then
                ASSERT(.false.)
                stat_adap = 0
                goto 99
            endif
        endif
!
        if (l_augm) then
            new_coef = new_coef*2.d0
        else
            new_coef = new_coef/2.d0
        endif
!
        if ((new_coef.ge.1.d8) .or. (new_coef.le.1.d-8)) l_stop = .true.
!
        if (l_stop) goto 15
    enddo
!
 15 continue
    if (l_stop) then
        new_coef = coef_init
        if (l_augm) then
            l_augm = .false.
            goto 10
        endif
        stat_adap = -1
    endif
!
 99 continue
!
    coef_adap = new_coef
end subroutine
