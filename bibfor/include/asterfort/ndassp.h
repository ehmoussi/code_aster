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
    subroutine ndassp(model          , nume_dof  , ds_material   , cara_elem  ,&
                      ds_constitutive, ds_measure, list_func_acti, ds_contact ,&
                      sddyna         ,&
                      hval_incr      , hval_algo , hval_veelem   , hval_veasse,&
                      ldccvg         , cndonn    , sdnume )
        use NonLin_Datastructure_type
        integer, intent(in) :: list_func_acti(*)
        character(len=19), intent(in) :: sddyna, sdnume
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        type(NL_DS_Material), intent(in) :: ds_material
        type(NL_DS_Measure), intent(inout) :: ds_measure
        character(len=24), intent(in) :: model, nume_dof
        character(len=24), intent(in) :: cara_elem
        type(NL_DS_Contact), intent(in) :: ds_contact
        character(len=19), intent(in) :: hval_algo(*), hval_incr(*)
        character(len=19), intent(in) :: hval_veasse(*), hval_veelem(*)
        character(len=19), intent(in) :: cndonn
        integer, intent(out) :: ldccvg
    end subroutine ndassp
end interface
