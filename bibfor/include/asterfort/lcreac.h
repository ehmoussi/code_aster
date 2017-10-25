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
    subroutine lcreac(nb_lagr       , indi_lagc      , elem_dime   , coef_upda_geom,&
                      nb_node_slav  , nb_node_mast   ,&
                      jv_geom       , jv_disp        , jv_disp_incr,&
                      elem_slav_coor, elem_mast_coor , jv_ddisp)
        integer, intent(in) :: elem_dime
        integer, intent(in) :: nb_lagr
        integer, intent(in) :: indi_lagc(10)
        integer, intent(in) :: nb_node_slav
        integer, intent(in) :: nb_node_mast
        real(kind=8), intent(in) :: coef_upda_geom     
        integer, intent(in) :: jv_geom
        integer, intent(in) :: jv_disp
        integer, intent(in) :: jv_disp_incr
        integer, intent(in), optional :: jv_ddisp
        real(kind=8), intent(inout) :: elem_slav_coor(elem_dime, nb_node_slav)
        real(kind=8), intent(inout) :: elem_mast_coor(elem_dime, nb_node_mast)
    end subroutine lcreac
end interface
