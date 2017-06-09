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
    subroutine load_neut_data(i_type_neum    , nb_type_neumz, type_calc_,&
                              load_type_ligr_, load_opti_r_ , load_opti_f_, load_para_r_,&
                              load_para_f_   , load_keyw_   , load_obje_  , nb_obje_)
        integer, intent(in) :: i_type_neum
        integer, intent(in) :: nb_type_neumz
        character(len=4), optional, intent(in) :: type_calc_
        character(len=6), optional, intent(out) :: load_type_ligr_
        character(len=16), optional, intent(out) :: load_opti_r_
        character(len=16), optional, intent(out) :: load_opti_f_
        character(len=8), optional, intent(out) :: load_para_r_(2)
        character(len=8), optional, intent(out) :: load_para_f_(2)
        character(len=24), optional, intent(out) :: load_keyw_
        character(len=10), optional, intent(out) :: load_obje_(2)
        integer, optional, intent(out) :: nb_obje_
    end subroutine load_neut_data
end interface
