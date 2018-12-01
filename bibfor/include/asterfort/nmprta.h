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
    subroutine nmprta(mesh, model          , nume_dof , numfix     , ds_material, cara_elem,&
                      ds_constitutive, list_load, ds_algopara, solveu     ,&
                      list_func_acti , ds_print , ds_measure , ds_algorom , sddisc,&
                      nume_inst      , hval_incr, hval_algo  , matass     , maprec,&
                      ds_contact     , sddyna   , hval_meelem, hval_measse, hval_veelem,&
                      hval_veasse    , sdnume   , ldccvg     , faccvg,&
                      rescvg    )
        use NonLin_Datastructure_type
        use ROM_Datastructure_type
        character(len=8), intent(in) :: mesh
        integer :: list_func_acti(*)
        integer :: nume_inst, faccvg, rescvg, ldccvg
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        type(NL_DS_AlgoPara), intent(in) :: ds_algopara
        type(NL_DS_Measure), intent(inout) :: ds_measure
        type(ROM_DS_AlgoPara), intent(in) :: ds_algorom
        type(NL_DS_Print), intent(inout) :: ds_print
        type(NL_DS_Material), intent(in) :: ds_material
        character(len=19) :: matass, maprec
        character(len=19) :: list_load, solveu, sddisc, sddyna, sdnume
        character(len=24) :: model, cara_elem
        character(len=24) :: nume_dof, numfix
        character(len=19) :: hval_algo(*), hval_incr(*)
        type(NL_DS_Contact), intent(inout) :: ds_contact
        character(len=19) :: hval_veelem(*), hval_veasse(*)
        character(len=19) :: hval_meelem(*), hval_measse(*)
    end subroutine nmprta
end interface
