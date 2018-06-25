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
    subroutine nmextr_read_2(sdextrz      , ds_inout, nb_keyw_fact, list_field, rela_field_keyw,&
                             nb_field_comp)
        use NonLin_Datastructure_type
            type(NL_DS_InOut), intent(in) :: ds_inout
        character(len=*), intent(in) :: sdextrz
        integer, intent(in) :: nb_keyw_fact
        character(len=24), pointer :: list_field(:)
        integer, pointer :: rela_field_keyw(:)
        integer, intent(in) :: nb_field_comp
    end subroutine nmextr_read_2
end interface
