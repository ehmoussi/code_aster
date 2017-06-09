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
    subroutine me2mme_evol(model_    , cara_elem_, mate_      , nharm    , base_    ,&
                           i_load    , load_name , ligrel_calc, inst_prev, inst_curr,&
                           inst_theta, resu_elem , vect_elem)
        character(len=*), intent(in) :: model_
        character(len=*), intent(in) :: cara_elem_
        character(len=*), intent(in) :: mate_
        integer, intent(in) :: nharm
        character(len=*), intent(in) :: base_
        integer, intent(in) :: i_load
        character(len=8), intent(in) :: load_name
        character(len=19), intent(in) :: ligrel_calc
        real(kind=8), intent(in) :: inst_prev 
        real(kind=8), intent(in) :: inst_curr
        real(kind=8), intent(in) :: inst_theta 
        character(len=19), intent(inout) :: resu_elem
        character(len=19), intent(in) :: vect_elem
    end subroutine me2mme_evol
end interface
