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
! aslint: disable=W1504
!
interface
    subroutine nmnewt(mesh       , model    , numins         , numedd    , numfix   ,&
                      ds_material, cara_elem, ds_constitutive, list_load ,&
                      ds_algopara, fonact   , ds_measure     , sderro    , ds_print ,&
                      sdnume     , sddyna   , sddisc         , sdcrit    , sdsuiv   ,&
                      sdpilo     , ds_conv  , solveu         , maprec    , matass   ,&
                      ds_inout   , valinc   , solalg         , meelem    , measse   ,&
                      veelem     , veasse   , ds_contact     , ds_algorom, eta      ,&
                      nbiter  )
        use NonLin_Datastructure_type
        use Rom_Datastructure_type
        character(len=8), intent(in) :: mesh
        character(len=24), intent(in) :: model
        integer :: numins
        character(len=24) :: numedd
        character(len=24) :: numfix
        type(NL_DS_Material), intent(in) :: ds_material
        character(len=24), intent(in) :: cara_elem
        type(NL_DS_Constitutive), intent(inout) :: ds_constitutive
        character(len=19), intent(in) :: list_load
        type(NL_DS_AlgoPara), intent(in) :: ds_algopara
        integer :: fonact(*)
        type(NL_DS_Measure), intent(inout) :: ds_measure
        character(len=24) :: sderro
        type(NL_DS_Print), intent(inout) :: ds_print
        character(len=19) :: sdnume
        character(len=19) :: sddyna
        character(len=19) :: sddisc
        character(len=19) :: sdcrit
        character(len=24) :: sdsuiv
        character(len=19) :: sdpilo
        type(NL_DS_Conv), intent(inout) :: ds_conv
        character(len=19) :: solveu
        character(len=19) :: maprec
        character(len=19) :: matass
        type(NL_DS_InOut), intent(in) :: ds_inout
        character(len=19) :: valinc(*)
        character(len=19) :: solalg(*)
        character(len=19) :: meelem(*)
        character(len=19) :: measse(*)
        character(len=19) :: veelem(*)
        character(len=19) :: veasse(*)
        type(NL_DS_Contact), intent(inout) :: ds_contact
        type(ROM_DS_AlgoPara), intent(inout) :: ds_algorom
        real(kind=8) :: eta
        integer :: nbiter
    end subroutine nmnewt
end interface
