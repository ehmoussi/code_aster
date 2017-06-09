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
    subroutine load_neum_comp(stop       , i_load    , load_name , load_nume  , load_type,&
                              ligrel_calc, nb_in_maxi, nb_in_prep, lpain      , lchin    ,&
                              base       , resu_elem , vect_elem , iden_direct, name_inputz)
        character(len=1), intent(in) :: stop
        integer, intent(in) :: i_load
        character(len=8), intent(in) :: load_name
        integer, intent(in) :: load_nume
        character(len=4), intent(in) :: load_type
        character(len=19), intent(in) :: ligrel_calc
        integer, intent(in) :: nb_in_maxi
        integer, intent(in) :: nb_in_prep
        character(len=*), intent(inout) :: lpain(nb_in_maxi)
        character(len=*), intent(inout) :: lchin(nb_in_maxi)
        character(len=19), intent(inout) :: resu_elem
        character(len=19), intent(in) :: vect_elem
        character(len=1), intent(in) :: base
        character(len=*), optional, intent(in) :: iden_direct
        character(len=*), optional, intent(in) :: name_inputz
    end subroutine load_neum_comp
end interface
