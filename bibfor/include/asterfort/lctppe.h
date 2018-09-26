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
#include "asterf_types.h"
!
interface
    subroutine lctppe(side      , l_axis    , l_upda_jaco,&
                      nb_node   , elem_dime , elem_code  ,&
                      elem_init , elem_coor , &
                      gauss_coor, shape_func, shape_dfunc,&
                      jacobian  , norm_g)
        character(len=*), intent(in) :: side
        integer, intent(in) :: elem_dime
        aster_logical, intent(in) :: l_axis, l_upda_jaco
        integer, intent(in) :: nb_node
        real(kind=8), intent(in) :: elem_init(elem_dime,nb_node)
        real(kind=8), intent(in) :: elem_coor(elem_dime,nb_node)
        character(len=8), intent(in) :: elem_code   
        real(kind=8), intent(in) :: gauss_coor(2)
        real(kind=8), intent(out) :: shape_func(9), shape_dfunc(2, 9)
        real(kind=8), intent(out) :: jacobian 
        real(kind=8), intent(out) :: norm_g(3)
    end subroutine lctppe
end interface
