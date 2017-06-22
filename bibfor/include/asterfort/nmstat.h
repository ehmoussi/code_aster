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
    subroutine nmstat(phasis, ds_measure, ds_print, sddisc, nume_inst, sderro)
        use NonLin_Datastructure_type
        character(len=1), intent(in) :: phasis
        type(NL_DS_Measure), intent(inout) :: ds_measure
        type(NL_DS_Print), intent(in) :: ds_print
        character(len=19), intent(in) :: sddisc
        integer, intent(in) :: nume_inst
        character(len=24), intent(in) :: sderro
    end subroutine nmstat
end interface
