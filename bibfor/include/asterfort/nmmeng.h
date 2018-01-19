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
    subroutine nmmeng(list_func_acti,&
                      ds_algorom, ds_print, ds_measure,&
                      ds_energy , ds_inout, ds_posttimestep)
        use NonLin_Datastructure_type
        use Rom_Datastructure_type
        integer, intent(in) :: list_func_acti(*)
        type(ROM_DS_AlgoPara), intent(inout) :: ds_algorom
        type(NL_DS_Print), intent(inout) :: ds_print
        type(NL_DS_Energy), intent(inout) :: ds_energy
        type(NL_DS_Measure), intent(inout) :: ds_measure
        type(NL_DS_InOut), intent(inout) :: ds_inout
        type(NL_DS_PostTimeStep), intent(inout) :: ds_posttimestep
    end subroutine nmmeng
end interface
