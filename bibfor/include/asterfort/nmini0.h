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
    subroutine nmini0(list_func_acti, eta      , nume_inst      , matass     , zmeelm    ,&
                      zmeass        , zveelm   , zveass         , zsolal     , zvalin    ,&
                      ds_print      , ds_conv  , ds_algopara    , ds_inout   , ds_contact,&
                      ds_measure    , ds_energy, ds_constitutive, ds_material)
        use NonLin_Datastructure_type
        integer, intent(out) :: list_func_acti(*)
        character(len=19), intent(out) :: matass
        integer, intent(out) :: nume_inst
        real(kind=8), intent(out) :: eta
        integer, intent(in) :: zmeelm
        integer, intent(in) :: zmeass
        integer, intent(in) :: zveelm
        integer, intent(in) :: zveass
        integer, intent(in) :: zsolal
        integer, intent(in) :: zvalin
        type(NL_DS_Print), intent(out) :: ds_print
        type(NL_DS_Conv), intent(out) :: ds_conv
        type(NL_DS_AlgoPara), intent(out) :: ds_algopara
        type(NL_DS_InOut), intent(out) :: ds_inout
        type(NL_DS_Contact), intent(out) :: ds_contact
        type(NL_DS_Measure), intent(out) :: ds_measure
        type(NL_DS_Energy), intent(out) :: ds_energy
        type(NL_DS_Constitutive), intent(out) :: ds_constitutive
        type(NL_DS_Material), intent(out) :: ds_material
    end subroutine nmini0
end interface
