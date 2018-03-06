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
    subroutine nmchht(model    , mate     , cara_elem  , ds_constitutive,&
                      list_load, nume_dof , varc_refe  , list_func_acti, ds_measure,&
                      sddyna   , sddisc   , sdnume     , &
                      hval_incr, hval_algo, hval_veasse, hval_measse   , ds_inout)
        use NonLin_Datastructure_type
        character(len=24), intent(in) :: model
        character(len=24), intent(in) :: mate
        character(len=24), intent(in) :: cara_elem
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        character(len=24), intent(in) :: nume_dof
        character(len=19), intent(in) :: list_load
        character(len=24), intent(in) :: varc_refe
        integer, intent(in) :: list_func_acti(*)
        type(NL_DS_Measure), intent(inout) :: ds_measure
        character(len=19), intent(in) :: sddyna
        character(len=19), intent(in) :: sddisc
        character(len=19), intent(in) :: sdnume
        character(len=19), intent(in) :: hval_incr(*)
        character(len=19), intent(in) :: hval_algo(*)
        character(len=19), intent(in) :: hval_veasse(*)
        character(len=19), intent(in) :: hval_measse(*)
        type(NL_DS_InOut), intent(in) :: ds_inout
    end subroutine nmchht
end interface
