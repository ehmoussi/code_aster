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
interface
    subroutine lccoma(elem_dime    , nb_node_mast   , nb_node_slav, nb_lagr,&
                      l_norm_smooth, norm           , indi_lagc   ,&
                      poidpg       , shape_mast_func, jaco_upda   ,&
                      mmat          )
        integer, intent(in) :: elem_dime
        integer, intent(in) :: nb_node_mast
        integer, intent(in) :: nb_node_slav
        integer, intent(in) :: nb_lagr
        aster_logical, intent(in) :: l_norm_smooth
        real(kind=8), intent(in) :: norm(3)
        integer, intent(in) :: indi_lagc(10)
        real(kind=8), intent(in) :: poidpg
        real(kind=8), intent(in) :: shape_mast_func(9)
        real(kind=8), intent(in) :: jaco_upda
        real(kind=8), intent(inout) :: mmat(55,55)
    end subroutine lccoma
end interface
