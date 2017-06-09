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
    subroutine nmetcc(field_type, algo_name, init_name,&
                      compor    , sddyna   , sdpost   , ds_contact,&
                      hydr      , temp_init, hydr_init)
        use NonLin_Datastructure_type 
        character(len=24), intent(in) :: field_type
        character(len=24), intent(out) :: algo_name
        character(len=24), intent(out) :: init_name
        type(NL_DS_Contact), optional, intent(in) :: ds_contact
        character(len=19), optional, intent(in) :: compor
        character(len=19), optional, intent(in) :: sddyna
        character(len=19), optional, intent(in) :: sdpost
        character(len=24), optional, intent(in) :: hydr
        character(len=24), optional, intent(in) :: hydr_init
        character(len=24), optional, intent(in) :: temp_init
    end subroutine nmetcc
end interface
