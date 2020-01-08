! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
interface
    subroutine ndassp(list_func_acti, ds_contact , ds_system,&
                      sddyna        , hval_veasse, cndonn)
        use NonLin_Datastructure_type
        integer, intent(in) :: list_func_acti(*)
        type(NL_DS_Contact), intent(in) :: ds_contact
        character(len=19), intent(in) :: sddyna
        character(len=19), intent(in) :: hval_veasse(*)
        type(NL_DS_System), intent(in) :: ds_system
        character(len=19), intent(in) :: cndonn
    end subroutine ndassp
end interface
