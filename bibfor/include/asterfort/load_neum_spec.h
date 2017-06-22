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
    subroutine load_neum_spec(load_name    , load_nume  , load_type  , ligrel_calc, i_type_neum,&
                              nb_type_neumz, nb_in_maxi , nb_in_prep , lchin      , lpain      ,&
                              nb_in_add    , load_ligrel, load_option, matr_type  , iden_direct,&
                              name_inputz  )
        character(len=8), intent(in) :: load_name
        integer, intent(in) :: load_nume
        character(len=19), intent(in) :: ligrel_calc
        character(len=4), intent(in) :: load_type
        integer, intent(in) :: i_type_neum
        integer, intent(in) :: nb_type_neumz
        integer, intent(in) :: nb_in_maxi
        integer, intent(in) :: nb_in_prep
        character(len=*), intent(inout) :: lpain(nb_in_maxi)
        character(len=*), intent(inout) :: lchin(nb_in_maxi)
        integer, intent(out) :: nb_in_add
        character(len=19), intent(out) :: load_ligrel
        character(len=16), intent(out) :: load_option
        character(len=8), optional, intent(out) :: matr_type
        character(len=*), optional, intent(in) :: iden_direct
        character(len=*), optional, intent(in) :: name_inputz
    end subroutine load_neum_spec
end interface
