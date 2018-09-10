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
    subroutine ndexpl(modele  , numedd         , numfix  , ds_material, carele,&
                      ds_constitutive, lischa  , ds_algopara, fonact,&
                      ds_print, ds_measure     , sdnume  , sddyna     , sddisc,&
                      sderro  , valinc         , numins  , solalg     , solveu,&
                      matass  , maprec         , ds_inout, meelem     , measse,&
                      veelem  , veasse         , nbiter  )
        use NonLin_Datastructure_type
        character(len=24) :: modele
        character(len=24) :: numedd
        character(len=24) :: numfix
        type(NL_DS_Material), intent(in) :: ds_material
        character(len=24) :: carele
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        character(len=19) :: lischa
        type(NL_DS_AlgoPara), intent(in) :: ds_algopara
        integer :: fonact(*)
        type(NL_DS_InOut), intent(in) :: ds_inout
        type(NL_DS_Print), intent(inout) :: ds_print
        type(NL_DS_Measure), intent(inout) :: ds_measure
        character(len=19) :: sdnume
        character(len=19) :: sddyna
        character(len=19) :: sddisc
        character(len=24) :: sderro
        character(len=19) :: valinc(*)
        integer :: numins
        character(len=19) :: solalg(*)
        character(len=19) :: solveu
        character(len=19) :: matass
        character(len=19) :: maprec
        character(len=19) :: meelem(*)
        character(len=19) :: measse(*)
        character(len=19) :: veelem(*)
        character(len=19) :: veasse(*)
        integer :: nbiter
    end subroutine ndexpl
end interface
