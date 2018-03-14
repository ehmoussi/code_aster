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
    subroutine nmforc_pred(list_func_acti,&
                           model         , cara_elem      , nume_dof,&
                           list_load     , sddyna         ,&
                           ds_material   , ds_constitutive,&
                           ds_measure    , &
                           sddisc        , nume_inst      ,&
                           hval_incr     , hval_algo      ,&
                           hval_veelem   , hval_veasse    ,&
                           hval_measse)
        use NonLin_Datastructure_type
        integer, intent(in) :: list_func_acti(*)
        character(len=24), intent(in) :: model, cara_elem, nume_dof
        character(len=19), intent(in) :: list_load, sddyna
        type(NL_DS_Material), intent(in) :: ds_material
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        type(NL_DS_Measure), intent(inout) :: ds_measure
        character(len=19), intent(in) :: sddisc
        integer, intent(in) :: nume_inst
        character(len=19), intent(in) :: hval_incr(*), hval_algo(*)
        character(len=19), intent(in) :: hval_veelem(*), hval_veasse(*)
        character(len=19), intent(in) :: hval_measse(*)
    end subroutine nmforc_pred
end interface
