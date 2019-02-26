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
!
#include "asterf_types.h"
!
interface
    subroutine lcstco(l_upda_jaco , l_norm_smooth, i_reso_geom ,&
                      lagrc_curr  , gap_curr     ,&
                      indi_cont   , &
                      gapi        , nmcp         ,&
                      nb_poin_inte, poin_inte_sl , poin_inte_ma)
        aster_logical, intent(out) :: l_upda_jaco
        aster_logical, intent(out) :: l_norm_smooth
        integer, intent(out) :: i_reso_geom
        real(kind=8), intent(out) :: lagrc_curr
        real(kind=8), intent(out) :: gap_curr
        integer, intent(out) :: indi_cont
        real(kind=8), intent(out) :: gapi
        integer, intent(out) :: nmcp
        integer, intent(out) :: nb_poin_inte
        real(kind=8), intent(out) :: poin_inte_sl(16)
        real(kind=8), intent(out) :: poin_inte_ma(16)
    end subroutine lcstco
end interface
