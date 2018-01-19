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
    subroutine load_neum_prep(model    , cara_elem , mate      , load_type     , inst_prev,&
                              inst_curr, inst_theta, nb_in_maxi, nb_in_prep    , lchin    ,&
                              lpain    , varc_curr , disp_prev , disp_cumu_inst, compor   ,&
                              nharm    , strx_prev_, vite_curr_)
        character(len=24), intent(in) :: model
        character(len=24), intent(in) :: cara_elem
        character(len=24), intent(in) :: mate
        integer, intent(in) :: nb_in_maxi
        character(len=4), intent(in) :: load_type
        real(kind=8), intent(in) :: inst_prev 
        real(kind=8), intent(in) :: inst_curr
        real(kind=8), intent(in) :: inst_theta 
        character(len=8), intent(inout) :: lpain(nb_in_maxi)
        character(len=19), intent(inout) :: lchin(nb_in_maxi)
        integer, intent(out) :: nb_in_prep
        character(len=19), optional, intent(in) :: varc_curr
        character(len=19), optional, intent(in) :: disp_prev
        character(len=19), optional, intent(in) :: disp_cumu_inst
        character(len=24), optional, intent(in) :: compor
        integer, optional, intent(in) :: nharm
        character(len=19), optional, intent(in) :: strx_prev_
        character(len=19), optional, intent(in) :: vite_curr_
    end subroutine load_neum_prep
end interface
