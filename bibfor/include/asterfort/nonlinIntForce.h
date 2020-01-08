! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
    subroutine nonlinIntForce(phaseType     ,&
                              model         , cara_elem      ,&
                              list_func_acti, iter_newt      , sdnume,&
                              ds_material   , ds_constitutive,&
                              ds_system     , ds_measure     ,&
                              hval_incr     , hval_algo      ,&
                              ldccvg        ,&
                              hhoField_     , sddyna_        ,&
                              time_prev_    , time_curr_     ,&
                              ds_algorom_)
        use NonLin_Datastructure_type
        use HHO_type
        use Rom_Datastructure_type
        integer, intent(in) :: phaseType
        character(len=24), intent(in) :: model, cara_elem
        integer, intent(in) :: list_func_acti(*)
        character(len=19), intent(in) :: sdnume
        type(NL_DS_Material), intent(in) :: ds_material
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        type(NL_DS_System), intent(in) :: ds_system
        type(NL_DS_Measure), intent(inout) :: ds_measure
        integer, intent(in) :: iter_newt
        character(len=19), intent(in) :: hval_incr(*), hval_algo(*)
        integer, intent(out) :: ldccvg
        type(HHO_Field), optional, intent(in) :: hhoField_
        character(len=19), optional, intent(in) :: sddyna_
        real(kind=8), optional, intent(in) :: time_prev_, time_curr_
        type(ROM_DS_AlgoPara), optional, intent(in) :: ds_algorom_
    end subroutine nonlinIntForce
end interface
