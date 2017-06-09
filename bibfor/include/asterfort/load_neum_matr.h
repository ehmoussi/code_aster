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
    subroutine load_neum_matr(idx_load    , idx_matr  , load_name , load_nume, load_type,&
                              ligrel_model, nb_in_maxi, nb_in_prep, lpain    , lchin    ,&
                              matr_elem   )
        character(len=8), intent(in) :: load_name
        integer, intent(in) :: idx_load
        integer, intent(inout) :: idx_matr
        integer, intent(in) :: load_nume
        character(len=4), intent(in) :: load_type
        character(len=19), intent(in) :: ligrel_model
        integer, intent(in) :: nb_in_maxi
        integer, intent(in) :: nb_in_prep
        character(len=*), intent(inout) :: lpain(nb_in_maxi)
        character(len=*), intent(inout) :: lchin(nb_in_maxi)
        character(len=19), intent(in) :: matr_elem
    end subroutine load_neum_matr
end interface
