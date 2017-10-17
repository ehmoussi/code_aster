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
! aslint: disable=W1504
!
interface
    subroutine nminit(mesh      , model     , mate       , cara_elem      , list_load ,&
                      numedd    , numfix    , ds_algopara, ds_constitutive, maprec    ,&
                      solver    , numins    , sddisc     , sdnume         , sdcrit    ,&
                      varc_refe , fonact    , sdpilo     , sddyna         , ds_print  ,&
                      sd_suiv   , sd_obsv   , sderro     , ds_posttimestep, ds_inout  ,&
                      ds_energy , ds_conv   , sdcriq     , valinc         , solalg    ,&
                      measse    , veelem    , meelem     , veasse         , ds_contact,&
                      ds_measure, ds_algorom)
        use NonLin_Datastructure_type
        use Rom_Datastructure_type
        character(len=8), intent(in) :: mesh
        character(len=24), intent(in) :: model
        character(len=24), intent(in) :: mate
        character(len=24), intent(in) :: cara_elem
        character(len=19), intent(in) :: list_load
        character(len=24) :: numedd
        character(len=24) :: numfix
        type(NL_DS_AlgoPara), intent(inout) :: ds_algopara
        type(NL_DS_Constitutive), intent(inout) :: ds_constitutive
        character(len=19) :: maprec
        character(len=19), intent(in) :: solver
        integer :: numins
        character(len=19) :: sddisc
        character(len=19) :: sdnume
        character(len=19) :: sdcrit
        character(len=24) :: varc_refe
        integer :: fonact(*)
        character(len=19) :: sdpilo
        character(len=19) :: sddyna
        type(NL_DS_Print), intent(inout) :: ds_print
        character(len=24), intent(out) :: sd_suiv
        character(len=19), intent(out) :: sd_obsv
        character(len=24) :: sderro
        type(NL_DS_PostTimeStep), intent(in) :: ds_posttimestep
        type(NL_DS_InOut), intent(inout) :: ds_inout
        type(NL_DS_Energy), intent(inout) :: ds_energy
        type(NL_DS_Conv), intent(inout) :: ds_conv
        character(len=24) :: sdcriq
        character(len=19) :: valinc(*)
        character(len=19) :: solalg(*)
        character(len=19) :: measse(*)
        character(len=19) :: veelem(*)
        character(len=19) :: meelem(*)
        character(len=19) :: veasse(*)
        type(NL_DS_Contact), intent(inout) :: ds_contact
        type(NL_DS_Measure), intent(inout) :: ds_measure
        type(ROM_DS_AlgoPara), intent(inout) :: ds_algorom
    end subroutine nminit
end interface
