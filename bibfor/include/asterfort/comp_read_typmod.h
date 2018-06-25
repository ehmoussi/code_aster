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
interface
    subroutine comp_read_typmod(mesh     , v_model_elem, elem_type    ,&
                                keywf    , i_comp      , rela_comp    , type_cpla_in,&
                                model_dim, model_mfront, type_cpla_out)
        character(len=8), intent(in) :: mesh
        integer, pointer :: v_model_elem(:)
        integer, intent(in) :: elem_type 
        character(len=16), intent(in) :: keywf
        integer, intent(in) :: i_comp
        character(len=16), intent(in) :: rela_comp
        character(len=16), intent(in) :: type_cpla_in
        character(len=16), intent(out) :: model_mfront
        integer, intent(out) :: model_dim
        character(len=16), intent(out) :: type_cpla_out
    end subroutine comp_read_typmod
end interface
