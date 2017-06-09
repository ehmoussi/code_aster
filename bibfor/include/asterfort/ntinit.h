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
    subroutine ntinit(model   , mate  , cara_elem, list_load, para    ,&
                      nume_dof, l_stat, l_evol   , sddisc   , ds_inout,&
                      mesh    , time)
        use NonLin_Datastructure_type
        character(len=24), intent(in) :: model
        character(len=24), intent(in) :: mate
        character(len=24), intent(in) :: cara_elem
        character(len=19), intent(in) :: list_load
        real(kind=8), intent(in) :: para(*)
        character(len=19), intent(in) :: sddisc
        type(NL_DS_InOut), intent(inout) :: ds_inout
        character(len=24), intent(out) :: nume_dof
        aster_logical, intent(out) :: l_stat
        aster_logical, intent(out) :: l_evol
        character(len=8), intent(out) :: mesh
        character(len=24), intent(out) :: time
    end subroutine ntinit
end interface 
