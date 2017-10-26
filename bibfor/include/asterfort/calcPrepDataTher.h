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
interface
    subroutine calcPrepDataTher(model        , temp_prev     , incr_temp   ,&
                                time_curr    , deltat        , theta       , khi,&
                                time         , temp_curr     ,&
                                ve_charther  , me_mtanther   , ve_dirichlet,&
                                ve_evolther_l, ve_evolther_nl, ve_resither)
        character(len=24), intent(in) :: model
        character(len=19), intent(in) :: temp_prev, incr_temp 
        real(kind=8), intent(in) :: time_curr, deltat, theta, khi
        character(len=24), intent(out) :: time
        character(len=19), intent(out) :: temp_curr
        character(len=24), intent(out) :: ve_charther
        character(len=24), intent(out) :: me_mtanther
        character(len=24), intent(out) :: ve_evolther_l, ve_evolther_nl
        character(len=24), intent(out) :: ve_resither
        character(len=*), intent(out) :: ve_dirichlet
    end subroutine calcPrepDataTher
end interface
