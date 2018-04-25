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
    subroutine nmrelp(model          , nume_dof , ds_material, cara_elem ,&
                      ds_constitutive, list_load, list_func_acti, iter_newt , ds_measure,&
                      sdnume         , sddyna   , ds_algopara, ds_contact, valinc    ,&
                      solalg         , veelem   , veasse     , ds_conv   , ldccvg)
        use NonLin_Datastructure_type
        integer :: list_func_acti(*)
        integer :: iter_newt, ldccvg
        type(NL_DS_AlgoPara), intent(in) :: ds_algopara
        type(NL_DS_Contact), intent(in) :: ds_contact
        type(NL_DS_Measure), intent(inout) :: ds_measure
        character(len=19) :: list_load, sddyna, sdnume
        type(NL_DS_Material), intent(in) :: ds_material
        character(len=24) :: model, nume_dof, cara_elem
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        character(len=19) :: veelem(*), veasse(*)
        character(len=19) :: solalg(*), valinc(*)
        type(NL_DS_Conv), intent(inout) :: ds_conv
    end subroutine nmrelp
end interface
