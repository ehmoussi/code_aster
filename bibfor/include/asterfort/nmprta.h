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
! aslint: disable=W1504
!
interface
    subroutine nmprta(modele    , numedd         , numfix    , mate       , carele,&
                      comref    , ds_constitutive, lischa    , ds_algopara, solveu,&
                      fonact    , ds_print       , ds_measure, ds_algorom , sddisc,&
                      numins    , valinc         , solalg    , matass     , maprec,&
                      ds_contact, sddyna         , meelem    , measse     , veelem,&
                      veasse    , sdnume         , ds_inout  , ldccvg     , faccvg,&
                      rescvg    )
        use NonLin_Datastructure_type
        use ROM_Datastructure_type
        character(len=24) :: modele
        character(len=24) :: numedd
        character(len=24) :: numfix
        character(len=24) :: mate
        character(len=24) :: carele
        character(len=24) :: comref
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        character(len=19) :: lischa
        type(NL_DS_InOut), intent(in) :: ds_inout
        type(NL_DS_AlgoPara), intent(in) :: ds_algopara
        character(len=19) :: solveu
        integer :: fonact(*)
        type(NL_DS_Print), intent(inout) :: ds_print
        type(NL_DS_Measure), intent(inout) :: ds_measure
        type(ROM_DS_AlgoPara), intent(in) :: ds_algorom
        character(len=19) :: sddisc
        integer :: numins
        character(len=19) :: valinc(*)
        character(len=19) :: solalg(*)
        character(len=19) :: matass
        character(len=19) :: maprec
        type(NL_DS_Contact), intent(inout) :: ds_contact
        character(len=19) :: sddyna
        character(len=19) :: meelem(*)
        character(len=19) :: measse(*)
        character(len=19) :: veelem(*)
        character(len=19) :: veasse(*)
        character(len=19) :: sdnume
        integer :: ldccvg
        integer :: faccvg
        integer :: rescvg
    end subroutine nmprta
end interface
