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
interface
    subroutine nmnoli(sddisc, sderro, ds_constitutive, ds_print , sdcrit  ,&
                      fonact, sddyna, ds_posttimestep, modele   , mate    ,&
                      carele, sdpilo, ds_measure     , ds_energy, ds_inout,&
                      sdcriq)
        use NonLin_Datastructure_type
        character(len=19) :: sddisc
        character(len=24) :: sderro
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        type(NL_DS_Print), intent(in) :: ds_print
        character(len=19) :: sdcrit
        integer :: fonact(*)
        character(len=19) :: sddyna
        type(NL_DS_PostTimeStep), intent(in) :: ds_posttimestep
        character(len=24) :: modele
        character(len=24) :: mate
        character(len=24) :: carele
        character(len=19) :: sdpilo
        type(NL_DS_Measure), intent(inout) :: ds_measure
        type(NL_DS_Energy), intent(in) :: ds_energy
        type(NL_DS_InOut), intent(inout) :: ds_inout
        character(len=24) :: sdcriq
    end subroutine nmnoli
end interface
