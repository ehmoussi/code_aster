! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
    subroutine nmpost(model          , mesh           , cara_elem      , list_load,&
                      numedof        , numfix         , ds_system      ,&
                      ds_constitutive, ds_material   ,&
                      ds_contact     , ds_algopara    , list_func_acti ,&
                      ds_measure     , sddisc         , nume_inst      , eta      ,&
                      sd_obsv        , sderro         , sddyna         , &
                      hval_incr      , hval_algo      ,&
                      hval_meelem    , hval_measse    , hval_veasse    ,&
                      ds_energy      , ds_errorindic  ,&
                      ds_posttimestep)
        use NonLin_Datastructure_type
        character(len=24), intent(in) :: model
        character(len=8), intent(in) :: mesh
        character(len=24), intent(in) :: cara_elem
        character(len=19), intent(in) :: list_load
        character(len=24), intent(in) :: numedof, numfix
        type(NL_DS_System), intent(in) :: ds_system
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        type(NL_DS_Material), intent(in) :: ds_material
        type(NL_DS_Contact), intent(inout) :: ds_contact
        type(NL_DS_AlgoPara), intent(in) :: ds_algopara
        integer, intent(in) :: list_func_acti(*)
        type(NL_DS_Measure), intent(inout) :: ds_measure
        character(len=19), intent(in) :: sddisc
        integer, intent(in) :: nume_inst
        real(kind=8), intent(in) :: eta
        character(len=19), intent(in) :: sd_obsv
        character(len=24), intent(in) :: sderro
        character(len=19), intent(in) :: sddyna
        character(len=19), intent(in) :: hval_incr(*), hval_algo(*)
        character(len=19), intent(in) :: hval_meelem(*), hval_measse(*)
        character(len=19), intent(in) :: hval_veasse(*)
        type(NL_DS_Energy), intent(inout) :: ds_energy
        type(NL_DS_ErrorIndic), intent(inout) :: ds_errorindic
        type(NL_DS_PostTimeStep), intent(inout) :: ds_posttimestep
    end subroutine nmpost
end interface
