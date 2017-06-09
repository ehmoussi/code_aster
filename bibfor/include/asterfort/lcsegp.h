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
    subroutine lcsegp(elem_dime   , nb_lagr       , indi_lagc     ,&
                      nb_node_mast, elin_mast_coor, elin_mast_code,&
                      nb_node_slav, elin_slav_coor, elin_slav_code,&
                      poidspg     , gauss_coot    , jacobian      ,&
                      norm        , vtmp)
        integer, intent(in) :: elem_dime
        integer, intent(in) :: nb_lagr
        integer, intent(in) :: indi_lagc(10)
        integer, intent(in) :: nb_node_mast
        real(kind=8), intent(in) :: elin_mast_coor(elem_dime,nb_node_mast)
        character(len=8), intent(in) :: elin_mast_code
        integer, intent(in) :: nb_node_slav
        real(kind=8), intent(in) :: elin_slav_coor(elem_dime,nb_node_slav)
        character(len=8), intent(in) :: elin_slav_code
        real(kind=8), intent(in) :: poidspg
        real(kind=8), intent(in) :: gauss_coot(2)
        real(kind=8), intent(in) :: jacobian
        real(kind=8), intent(in) :: norm(3)
        real(kind=8), intent(inout) :: vtmp(55)
    end subroutine lcsegp
end interface
