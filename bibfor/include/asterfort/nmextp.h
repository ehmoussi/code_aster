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
    subroutine nmextp(keyw_fact, i_keyw_fact, field_type, field_disc, field  ,&
                  field_s  , list_poin  , list_spoi , nb_poin   , nb_spoi,&
                  type_extr_elem)
        character(len=16), intent(in) :: keyw_fact
        integer, intent(in) :: i_keyw_fact
        character(len=19), intent(in) :: field
        character(len=24), intent(in) :: field_type
        character(len=4) , intent(in) :: field_disc
        character(len=24), intent(in) :: field_s
        character(len=8), intent(out) :: type_extr_elem
        character(len=24), intent(in) :: list_poin
        character(len=24), intent(in) :: list_spoi
        integer, intent(out) :: nb_poin
        integer, intent(out) :: nb_spoi
    end subroutine nmextp
end interface
