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
!
interface
    subroutine nminmc(fonact, lischa     , sddyna    , modele     , ds_constitutive,&
                      numedd, numfix     , ds_contact, ds_algopara, solalg         ,&
                      valinc, ds_material, carele    , sddisc     , ds_measure     ,&
                      meelem, measse     , veelem)
        use NonLin_Datastructure_type        
        integer :: fonact(*)
        character(len=19) :: lischa
        character(len=19) :: sddyna
        character(len=24) :: modele
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        character(len=24) :: numedd
        character(len=24) :: numfix
        type(NL_DS_Contact), intent(in) :: ds_contact
        type(NL_DS_AlgoPara), intent(in) :: ds_algopara
        character(len=19) :: solalg(*)
        character(len=19) :: valinc(*)
        type(NL_DS_Material), intent(in) :: ds_material
        character(len=24) :: carele
        character(len=19) :: sddisc
        type(NL_DS_Measure), intent(inout) :: ds_measure
        character(len=19) :: meelem(*)
        character(len=19) :: measse(*)
        character(len=19) :: veelem(*)
    end subroutine nminmc
end interface
