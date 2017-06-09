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
interface
    subroutine apchoi(dist        , dist_mini, elem_indx, elem_indx_mini, tau1     ,&
                      tau1_mini   , tau2     , tau2_mini, ksi1          , ksi1_mini,&
                      ksi2        , ksi2_mini, proj_stat, proj_stat_mini, vect_pm  ,&
                      vect_pm_mini)
        integer, intent(in) :: proj_stat
        integer, intent(inout) :: proj_stat_mini
        real(kind=8), intent(in) :: dist
        real(kind=8), intent(inout) :: dist_mini
        integer, intent(in) :: elem_indx
        integer, intent(inout) :: elem_indx_mini
        real(kind=8), intent(in) :: tau1(3)
        real(kind=8), intent(inout) :: tau1_mini(3)
        real(kind=8), intent(in) :: tau2(3)
        real(kind=8), intent(inout) :: tau2_mini(3)
        real(kind=8), intent(in) :: vect_pm(3)
        real(kind=8), intent(inout) :: vect_pm_mini(3)
        real(kind=8), intent(in) :: ksi1
        real(kind=8), intent(inout) :: ksi1_mini
        real(kind=8), intent(in) :: ksi2
        real(kind=8), intent(inout) :: ksi2_mini
    end subroutine apchoi
end interface
