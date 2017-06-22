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
    subroutine load_neum_evcu(model    , ligrel_calc, cara_elem, load_name     , i_load,&
                              inst_curr, disp_prev  , strx_prev, disp_cumu_inst, vite_curr,&
                              base     , resu_elem  , vect_elem)
        character(len=24), intent(in) :: model
        character(len=24), intent(in) :: cara_elem
        character(len=24), intent(in)  :: ligrel_calc
        real(kind=8), intent(in) :: inst_curr
        character(len=8), intent(in) :: load_name
        character(len=19), intent(in) :: disp_prev
        character(len=19), intent(in) :: strx_prev
        character(len=19), intent(in) :: disp_cumu_inst
        character(len=19), intent(in) :: vite_curr
        integer, intent(in) :: i_load
        character(len=19), intent(inout) :: resu_elem
        character(len=19), intent(in) :: vect_elem
        character(len=1), intent(in) :: base
    end subroutine load_neum_evcu
end interface
