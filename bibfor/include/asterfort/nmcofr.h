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
!
interface
    subroutine nmcofr(mesh      , disp_curr, disp_cumu_inst, disp_iter, solver        ,&
                      nume_dof  , matr_asse, iter_newt     , time_curr, resi_glob_rela,&
                      ds_measure, ds_contact    , ctccvg)
        use NonLin_Datastructure_type
        character(len=8), intent(in) :: mesh
        character(len=19), intent(in) :: disp_curr
        character(len=19), intent(in) :: disp_cumu_inst
        character(len=19), intent(in) :: disp_iter
        character(len=19), intent(in) :: solver
        character(len=14), intent(in) :: nume_dof
        character(len=19), intent(in) :: matr_asse
        integer, intent(in) :: iter_newt
        real(kind=8), intent(in) :: time_curr
        real(kind=8), intent(in) :: resi_glob_rela
        type(NL_DS_Measure), intent(inout) :: ds_measure
        type(NL_DS_Contact), intent(inout) :: ds_contact 
        integer, intent(out) :: ctccvg
    end subroutine nmcofr
end interface
