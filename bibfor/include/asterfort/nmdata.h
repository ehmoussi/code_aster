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
    subroutine nmdata(model    , mesh      , mate      , cara_elem  , ds_constitutive,&
                      list_load, solver    , ds_conv   , sddyna     , ds_posttimestep,&
                      ds_energy, sdcriq    , ds_print  , ds_algopara,&
                      ds_inout , ds_contact, ds_measure, ds_algorom)
        use NonLin_Datastructure_type
        use Rom_Datastructure_type
        character(len=*), intent(out) :: model
        character(len=*), intent(out) :: mesh
        character(len=*), intent(out) :: mate
        character(len=*), intent(out) :: cara_elem
        type(NL_DS_Constitutive), intent(inout) :: ds_constitutive
        character(len=*), intent(out) :: list_load
        character(len=*), intent(out) :: solver
        type(NL_DS_Conv), intent(inout) :: ds_conv
        character(len=19) :: sddyna
        type(NL_DS_PostTimeStep), intent(inout) :: ds_posttimestep
        type(NL_DS_Energy), intent(inout) :: ds_energy
        character(len=24) :: sdcriq
        type(NL_DS_Print), intent(inout) :: ds_print
        type(NL_DS_AlgoPara), intent(inout) :: ds_algopara
        type(NL_DS_InOut), intent(inout) :: ds_inout
        type(NL_DS_Contact), intent(inout) :: ds_contact
        type(NL_DS_Measure), intent(inout) :: ds_measure
        type(ROM_DS_AlgoPara), intent(inout) :: ds_algorom
    end subroutine nmdata
end interface
