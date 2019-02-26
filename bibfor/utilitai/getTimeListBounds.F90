! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
subroutine getTimeListBounds(sddisc, t_ini, t_end)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jelira.h"
!
character(len=19), intent(in) :: sddisc
real(kind=8), intent(out) :: t_ini, t_end
!
! --------------------------------------------------------------------------------------------------
!
! Get bounds of time list
!
! --------------------------------------------------------------------------------------------------
!
! In  sddisc           : datastructure for time discretization
! Out t_ini            : initial time from time list
! Out t_end            : final time from time list
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_time
    character(len=24) :: sddisc_ditr
    real(kind=8), pointer :: v_sddisc_ditr(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    sddisc_ditr = sddisc(1:19)//'.DITR'
    call jelira(sddisc_ditr, 'LONMAX', nb_time)
    call jeveuo(sddisc_ditr, 'E', vr = v_sddisc_ditr)
    t_ini = v_sddisc_ditr(1)
    t_end = v_sddisc_ditr(nb_time)
!
end subroutine
