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
subroutine nxconv(ther_crit_i, ther_crit_r, resi_rela, resi_maxi, conver)
!
implicit none
!
#include "asterf_types.h"
!
integer, intent(in) :: ther_crit_i(*)
real(kind=8), intent(in) :: ther_crit_r(*)
real(kind=8), intent(in) :: resi_rela, resi_maxi
aster_logical, intent(out) :: conver
!
! --------------------------------------------------------------------------------------------------
!
! THER_NON_LINE
!
! Evaluate convergence
!
! --------------------------------------------------------------------------------------------------
!
! In  ther_crit_i      : criteria for algorithm (integer)
! In  ther_crit_r      : criteria for algorithm (real)
! In  resi_rela        : value for RESI_GLOB_RELA
! In  resi_maxi        : value for RESI_GLOB_MAXI
! Out conver           : .true. if convergence
!
! --------------------------------------------------------------------------------------------------
!
    conver     = ASTER_FALSE
!
    if (ther_crit_i(1) .ne. 0) then
        if (resi_maxi .lt. ther_crit_r(1)) then
            conver = ASTER_TRUE
        else
            conver = ASTER_FALSE
        endif
    else
        if (resi_rela .lt. ther_crit_r(2)) then
            conver = ASTER_TRUE
        else
            conver = ASTER_FALSE
        endif
    endif
!
end subroutine
