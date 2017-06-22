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
    subroutine nmflma(typmat, mod45 , defo  , ds_algopara, modelz,&
                      mate  , carele, sddisc, sddyna     , fonact,&
                      numins, valinc, solalg, lischa     , comref,&
                      ds_contact, numedd, numfix,&
                      ds_constitutive, ds_measure, meelem,&
                      measse, veelem, nddle , ddlexc     , modrig,&
                      ldccvg, matass, matgeo)
        use NonLin_Datastructure_type
        character(len=16) :: typmat
        character(len=4) :: mod45
        integer :: defo
        type(NL_DS_AlgoPara), intent(in) :: ds_algopara
        character(len=*) :: modelz
        character(len=24) :: mate
        character(len=24) :: carele
        character(len=19) :: sddisc
        character(len=19) :: sddyna
        integer :: fonact(*)
        integer :: numins
        character(len=19) :: valinc(*)
        character(len=19) :: solalg(*)
        character(len=19) :: lischa
        character(len=24) :: comref
        type(NL_DS_Contact), intent(in) :: ds_contact
        character(len=24) :: numedd
        character(len=24) :: numfix
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        type(NL_DS_Measure), intent(inout) :: ds_measure
        character(len=19) :: meelem(*)
        character(len=19) :: measse(*)
        character(len=19) :: veelem(*)
        integer :: nddle
        character(len=24) :: ddlexc
        character(len=16) :: modrig
        integer :: ldccvg
        character(len=19) :: matass
        character(len=19) :: matgeo
    end subroutine nmflma
end interface
