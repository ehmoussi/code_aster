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
    subroutine nmrepl(modele         , numedd, mate       , carele, comref    ,&
                      ds_constitutive, lischa, ds_algopara, fonact, iterat    ,&
                      ds_measure     , sdpilo, sdnume     , sddyna, ds_contact,&
                      deltat         , valinc, solalg     , veelem, veasse    ,&
                      sddisc         , etan  , ds_conv    , eta   , offset    ,&
                      ldccvg         , pilcvg, matass )
        use NonLin_Datastructure_type
        character(len=24) :: modele
        character(len=24) :: numedd
        character(len=24) :: mate
        character(len=24) :: carele
        character(len=24) :: comref
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        character(len=19) :: lischa
        type(NL_DS_AlgoPara), intent(in) :: ds_algopara
        integer :: fonact(*)
        integer :: iterat
        type(NL_DS_Measure), intent(inout) :: ds_measure
        character(len=19) :: sdpilo
        character(len=19) :: sdnume
        character(len=19) :: sddyna
        type(NL_DS_Contact), intent(in) :: ds_contact
        real(kind=8) :: deltat
        character(len=19) :: valinc(*)
        character(len=19) :: solalg(*)
        character(len=19) :: veelem(*)
        character(len=19) :: veasse(*)
        character(len=19) :: sddisc
        real(kind=8) :: etan
        type(NL_DS_Conv), intent(inout) :: ds_conv
        real(kind=8) :: eta
        real(kind=8) :: offset
        integer :: ldccvg
        integer :: pilcvg
        character(len=19) :: matass
    end subroutine nmrepl
end interface
