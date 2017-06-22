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
    subroutine nmspec(modele     , numedd, numfix  , carele    , ds_constitutive,&
                      numins     , mate  , comref  , lischa    , ds_contact     ,&
                      ds_algopara, fonact, ds_print, ds_measure, sddisc         ,&
                      valinc     , solalg, meelem  , measse    , veelem         ,&
                      sddyna     , sdpost, sderro)
        use NonLin_Datastructure_type
        character(len=24) :: modele
        character(len=24) :: numedd
        character(len=24) :: numfix
        character(len=24) :: carele
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        integer :: numins
        character(len=24) :: mate
        character(len=24) :: comref
        character(len=19) :: lischa
        type(NL_DS_Contact), intent(in) :: ds_contact
        type(NL_DS_AlgoPara), intent(in) :: ds_algopara
        integer :: fonact(*)
        type(NL_DS_Print), intent(in) :: ds_print
        type(NL_DS_Measure), intent(inout) :: ds_measure
        character(len=19) :: sddisc
        character(len=19) :: valinc(*)
        character(len=19) :: solalg(*)
        character(len=19) :: meelem(*)
        character(len=19) :: measse(*)
        character(len=19) :: veelem(*)
        character(len=19) :: sddyna
        character(len=19) :: sdpost
        character(len=24) :: sderro
    end subroutine nmspec
end interface
