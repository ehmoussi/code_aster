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
    subroutine nmnpas(modele    , noma  , ds_material, carele    , fonact    ,&
                      ds_print  , sddisc, sdsuiv, sddyna    , sdnume    ,&
                      ds_measure, numedd, numins, ds_contact, &
                      valinc    , solalg, solveu, ds_conv   , lischa    )
        use NonLin_Datastructure_type
        character(len=24) :: modele
        character(len=8) :: noma
        type(NL_DS_Material), intent(in) :: ds_material
        character(len=24) :: carele
        integer :: fonact(*)
        type(NL_DS_Print), intent(inout) :: ds_print
        character(len=19) :: sddisc
        character(len=24) :: sdsuiv
        character(len=19) :: sddyna
        character(len=19) :: sdnume
        type(NL_DS_Measure), intent(inout) :: ds_measure
        character(len=24) :: numedd
        integer :: numins
        type(NL_DS_Contact), intent(inout) :: ds_contact
        character(len=19) :: valinc(*)
        character(len=19) :: solalg(*)
        character(len=19) :: solveu
        type(NL_DS_Conv), intent(inout) :: ds_conv
        character(len=19), intent(in) :: lischa
    end subroutine nmnpas
end interface
