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
    subroutine lcvect(elem_dime   ,&
                      l_axis      , l_upda_jaco   , l_norm_smooth ,&
                      nb_lagr     , indi_lagc     , lagrc         ,&
                      nb_node_slav, elem_slav_code, elem_slav_init, elga_fami_slav, elem_slav_coor,&
                      nb_node_mast, elem_mast_code, elem_mast_init, elga_fami_mast, elem_mast_coor,&
                      vect)
        integer, intent(in) :: elem_dime
        aster_logical, intent(in) :: l_axis, l_upda_jaco, l_norm_smooth
        integer, intent(in) :: nb_lagr, indi_lagc(10)
        real(kind=8), intent(in) :: lagrc
        character(len=8), intent(in) :: elem_slav_code, elem_mast_code
        integer, intent(in) :: nb_node_slav, nb_node_mast
        real(kind=8), intent(in):: elem_mast_init(27), elem_slav_init(27)
        real(kind=8), intent(in) :: elem_mast_coor(27), elem_slav_coor(27)
        character(len=8), intent(in) :: elga_fami_slav, elga_fami_mast
        real(kind=8), intent(inout) :: vect(55)
    end subroutine lcvect
end interface
