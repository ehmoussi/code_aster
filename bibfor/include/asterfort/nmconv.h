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
    subroutine nmconv(noma    , modele, mate   , numedd  , sdnume     ,&
                      fonact  , sddyna, ds_conv, ds_print, ds_measure,&
                      sddisc  , sdcrit , sderro  , ds_algopara, ds_algorom,&
                      ds_inout, comref, matass , solveu  , numins     ,&
                      iterat  , eta   , ds_contact, valinc  , solalg     ,&
                      measse  , veasse)
        use NonLin_Datastructure_type
        use Rom_Datastructure_type
        character(len=8) :: noma
        character(len=24) :: modele
        character(len=24) :: mate
        character(len=24) :: numedd
        character(len=19) :: sdnume
        integer :: fonact(*)
        character(len=19) :: sddyna
        type(NL_DS_Conv), intent(inout) :: ds_conv
        type(NL_DS_Print), intent(inout) :: ds_print
        type(NL_DS_Measure), intent(inout) :: ds_measure
        character(len=19) :: sddisc
        character(len=19) :: sdcrit
        character(len=24) :: sderro
        type(NL_DS_InOut), intent(in) :: ds_inout
        type(NL_DS_AlgoPara), intent(in) :: ds_algopara
        character(len=24) :: comref
        character(len=19) :: matass
        character(len=19) :: solveu
        integer :: numins
        integer :: iterat
        real(kind=8) :: eta
        type(NL_DS_Contact), intent(inout) :: ds_contact
        type(ROM_DS_AlgoPara), intent(in) :: ds_algorom
        character(len=19) :: valinc(*)
        character(len=19) :: solalg(*)
        character(len=19) :: measse(*)
        character(len=19) :: veasse(*)
    end subroutine nmconv
end interface
