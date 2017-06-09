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

!
!
#include "asterf_types.h"
!
interface
    subroutine approj(mesh          , newgeo        , sdcont_defi , node_mast_indx, l_pair_dire,&
                      pair_vect     , iter_maxi     , epsi_maxi   , tole_proj_ext , poin_coor  ,&
                      elem_mast_mini, proj_stat_mini, ksi1_mini   , ksi2_mini     , tau1_mini  ,&
                      tau2_mini     , dist_mini     , vect_pm_mini)
        character(len=8), intent(in) :: mesh
        character(len=19), intent(in) :: newgeo
        character(len=24), intent(in) :: sdcont_defi
        integer, intent(in) :: node_mast_indx
        aster_logical, intent(in) :: l_pair_dire
        real(kind=8), intent(in) :: pair_vect(3)
        integer, intent(in) :: iter_maxi
        real(kind=8), intent(in) :: epsi_maxi
        real(kind=8), intent(in) :: tole_proj_ext 
        real(kind=8), intent(in) :: poin_coor(3)
        real(kind=8), intent(out) :: tau1_mini(3)
        real(kind=8), intent(out) :: tau2_mini(3)
        real(kind=8), intent(out) :: vect_pm_mini(3)
        real(kind=8), intent(out) :: ksi1_mini
        real(kind=8), intent(out) :: ksi2_mini
        real(kind=8), intent(out) :: dist_mini
        integer, intent(out) :: proj_stat_mini
        integer, intent(out) :: elem_mast_mini
    end subroutine approj
end interface
