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
    subroutine nonlinDynaMDampCompute(phase    , sddyna     ,&
                                      nume_dof , ds_measure ,&
                                      hval_incr, hval_veasse)
        use NonLin_Datastructure_type
        character(len=10), intent(in) :: phase
        character(len=19), intent(in) :: sddyna
        character(len=24), intent(in) :: nume_dof
        type(NL_DS_Measure), intent(inout) :: ds_measure
        character(len=19), intent(in) :: hval_incr(*)
        character(len=19), intent(in) :: hval_veasse(*)
    end subroutine nonlinDynaMDampCompute
end interface
