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
    subroutine varinonu(model    , compor_  , sdresu_,&
                        nb_elem  , list_elem, nb_vari, name_vari,&
                        nume_vari)
        character(len=*), intent(in) :: model
        character(len=*), intent(in) :: compor_
        character(len=*), intent(in) :: sdresu_
        integer, intent(in) :: nb_elem
        integer, intent(in) :: list_elem(nb_elem)
        integer, intent(in) :: nb_vari
        character(len=16), intent(in) :: name_vari(nb_vari)
        character(len=8), intent(out) ::  nume_vari(nb_elem, nb_vari)
    end subroutine varinonu
end interface 
