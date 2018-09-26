! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
!
#include "asterf_types.h"
!
interface
    subroutine lcstco(l_previous, l_upda_jaco  ,&
                      lagrc_prev, lagrc_curr   ,&
                      gap_prev  , gap_curr     ,&
                      indi_cont , l_norm_smooth)
        aster_logical, intent(out) :: l_previous
        real(kind=8), intent(out) :: lagrc_curr, lagrc_prev
        real(kind=8), intent(out) :: gap_curr, gap_prev
        aster_logical, intent(out) :: l_upda_jaco
        integer, intent(out) :: indi_cont
        aster_logical, intent(out) :: l_norm_smooth
    end subroutine lcstco
end interface
