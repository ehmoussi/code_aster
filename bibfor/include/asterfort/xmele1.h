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
    subroutine xmele1(mesh  , model, ds_contact, ligrel, nfiss,&
                      chelem, param, option    , list_func_acti)
        use NonLin_Datastructure_type
        character(len=8), intent(in) :: mesh
        character(len=8), intent(in) :: model
        type(NL_DS_Contact), intent(in) :: ds_contact
        integer, intent(in) :: nfiss
        character(len=19), intent(in) :: chelem
        character(len=19), intent(in) :: ligrel
        character(len=*), intent(in) :: param
        character(len=*), intent(in) :: option
        integer, intent(in) :: list_func_acti(*)
    end subroutine xmele1
end interface
