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
!
interface
    subroutine ccchuc(sdresu_in, sdresu_out, field_type, nume_field_out, type_comp, &
                      crit, norm, nb_form, name_form, list_ordr, &
                      nb_ordr, iocc)
        character(len=8), intent(in) :: sdresu_in
        character(len=8), intent(in) :: sdresu_out
        character(len=16), intent(in) :: field_type
        character(len=16), intent(in) :: type_comp
        character(len=16), intent(in) :: crit
        character(len=16), intent(in) :: norm
        integer, intent(in) :: nb_form
        character(len=8), intent(in) :: name_form(nb_form)
        integer , intent(in) :: nume_field_out
        character(len=19), intent(in) :: list_ordr
        integer , intent(in) :: nb_ordr
        integer , intent(in) :: iocc
    end subroutine ccchuc
end interface
