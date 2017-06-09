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
    subroutine ntdata(list_load, solver, matcst   , coecst  , result,&
                      model    , mate  , cara_elem, ds_inout, theta )
        use NonLin_Datastructure_type
        character(len=19), intent(inout) :: list_load
        character(len=19), intent(in) :: solver
        aster_logical, intent(out) :: matcst
        aster_logical, intent(out) :: coecst
        character(len=8), intent(out) :: result
        character(len=24), intent(out) :: model
        character(len=24), intent(out) :: mate
        character(len=24), intent(out) :: cara_elem
        type(NL_DS_InOut), intent(inout) :: ds_inout
        real(kind=8), intent(out) :: theta
    end subroutine ntdata
end interface
