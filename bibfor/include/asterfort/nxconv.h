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
#include "asterf_types.h"
!
interface
    subroutine nxconv(ther_crit_i, ther_crit_r, resi_rela, resi_maxi, conver)
        integer, intent(in) :: ther_crit_i(*)
        real(kind=8), intent(in) :: ther_crit_r(*)
        real(kind=8), intent(in) :: resi_rela, resi_maxi
        aster_logical, intent(out) :: conver
    end subroutine nxconv
end interface
