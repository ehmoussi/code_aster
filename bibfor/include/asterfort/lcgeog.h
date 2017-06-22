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
    subroutine lcgeog(elem_dime     , nb_lagr       , indi_lagc ,&
                      nb_node_slav  , nb_node_mast  , &
                      algo_reso_geom, elem_mast_coor, elem_slav_coor,&
                      norm_smooth)
        integer, intent(in) :: elem_dime
        integer, intent(in) :: nb_lagr
        integer, intent(in) :: indi_lagc(10)
        integer, intent(in) :: nb_node_slav
        integer, intent(in) :: nb_node_mast
        integer, intent(in) :: algo_reso_geom
        real(kind=8), intent(inout) :: elem_slav_coor(elem_dime, nb_node_slav)
        real(kind=8), intent(inout) :: elem_mast_coor(elem_dime, nb_node_mast)
        integer, intent(out) :: norm_smooth  
    end subroutine lcgeog
end interface
