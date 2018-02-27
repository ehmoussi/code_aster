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
    subroutine nmener(valinc, veasse, measse, sddyna, eta        ,&
                      ds_energy, fonact, numedd, numfix, ds_algopara,&
                      meelem, numins, modele, ds_material, carele     ,&
                      ds_constitutive, ds_measure, sddisc, solalg, lischa,&
                      veelem, ds_inout)
        use NonLin_Datastructure_type
        character(len=19) :: valinc(*)
        character(len=19) :: veasse(*)
        character(len=19) :: measse(*)
        character(len=19) :: sddyna
        real(kind=8) :: eta
        type(NL_DS_Energy), intent(inout) :: ds_energy
        integer :: fonact(*)
        character(len=24) :: numedd
        character(len=24) :: numfix
        character(len=19) :: meelem(*)
        integer :: numins
        character(len=24) :: modele
        type(NL_DS_Material), intent(in) :: ds_material
        character(len=24) :: carele
        type(NL_DS_InOut), intent(in) :: ds_inout
        type(NL_DS_AlgoPara), intent(in) :: ds_algopara
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        type(NL_DS_Measure), intent(inout) :: ds_measure
        character(len=19) :: sddisc
        character(len=19) :: solalg(*)
        character(len=19) :: lischa
        character(len=19) :: veelem(*)
    end subroutine nmener
end interface
