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
    subroutine nmresi(mesh       , list_func_acti, ds_material,&
                      nume_dof   , sdnume        , sddyna     ,&
                      ds_conv    , ds_print      , ds_contact ,&
                      ds_inout   , ds_algorom    ,&
                      matass     , nume_inst     , eta        ,&
                      hval_incr  , hval_algo     ,&
                      hval_veasse, hval_measse   ,&
                      r_equi_vale, r_char_vale)
        use NonLin_Datastructure_type
        use Rom_Datastructure_type
        character(len=8), intent(in) :: mesh
        integer, intent(in) :: list_func_acti(*)
        type(NL_DS_Material), intent(in) :: ds_material
        character(len=24), intent(in) :: nume_dof
        character(len=19), intent(in) :: sddyna, sdnume
        type(NL_DS_Conv), intent(inout) :: ds_conv
        type(NL_DS_Print), intent(inout) :: ds_print
        type(NL_DS_Contact), intent(inout) :: ds_contact
        type(NL_DS_InOut), intent(in) :: ds_inout
        type(ROM_DS_AlgoPara), intent(in) :: ds_algorom
        character(len=19), intent(in) :: matass
        integer, intent(in) :: nume_inst
        real(kind=8), intent(in) :: eta
        character(len=19), intent(in) :: hval_incr(*), hval_algo(*)
        character(len=19), intent(in) :: hval_measse(*), hval_veasse(*)
        real(kind=8), intent(out) :: r_char_vale, r_equi_vale
    end subroutine nmresi
end interface
