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

subroutine dfllli(listr8_sdaster, dtmin, nb_inst)
!
implicit none
!
#include "asterc/r8maem.h"
#include "asterc/r8prem.h"
#include "asterfort/jelira.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=19), intent(in) :: listr8_sdaster
    real(kind=8), intent(out) :: dtmin
    integer, intent(out) :: nb_inst
!
! --------------------------------------------------------------------------------------------------
!
! Utility - List of times
!
! Some checks
!
! --------------------------------------------------------------------------------------------------
!
! In  listr8_sdaster   : list of reals (listr8_sdaster)
! Out dtmin            : minimum time between two steps
! Out nb_inst          : number of time steps in list
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_inst
    real(kind=8) :: deltat
    real(kind=8), pointer :: v_vale(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    dtmin = r8maem()
!
! - Access to list of times
!
    call jeveuo(listr8_sdaster//'.VALE', 'L', vr=v_vale)
    call jelira(listr8_sdaster//'.VALE', 'LONMAX', nb_inst)
!
! - At least one step
!
    if (nb_inst .lt. 2) then
        call utmess('F', 'DISCRETISATION_95')
    endif
!
! - Minimum time between two steps
!
    do i_inst = 1, nb_inst-1
        deltat = v_vale(1+i_inst) - v_vale(i_inst)
        dtmin = min(deltat,dtmin)
    end do
!
! - List must increase
!
    if (dtmin .le. r8prem()) then
        call utmess('F', 'DISCRETISATION_87')
    endif
!
end subroutine
