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
    subroutine nxinit(model , mate    , cara_elem , compor, list_load,&
                      para  , nume_dof, l_stat    , l_evol, l_rom    ,&
                      sddisc, ds_inout, vhydr     , sdobse, mesh     ,&
                      sdcrit, time    , ds_algorom, l_line_search)
        use NonLin_Datastructure_type
        use Rom_Datastructure_type
        character(len=24), intent(in) :: model
        character(len=24), intent(in) :: mate
        character(len=24), intent(in) :: cara_elem
        character(len=24), intent(in) :: compor
        character(len=19), intent(in) :: list_load
        real(kind=8), intent(in) :: para(*)
        character(len=24), intent(out) :: nume_dof
        aster_logical, intent(out) :: l_stat
        aster_logical, intent(out) :: l_evol
        aster_logical, intent(out) :: l_rom
        character(len=19), intent(in) :: sddisc
        type(NL_DS_InOut), intent(inout) :: ds_inout
        character(len=24), intent(in) :: vhydr
        character(len=19), intent(out) :: sdobse
        character(len=8), intent(out) :: mesh
        character(len=19), intent(in) :: sdcrit
        character(len=24), intent(out) :: time
        type(ROM_DS_AlgoPara), intent(inout) :: ds_algorom
        aster_logical, intent(in) :: l_line_search
    end subroutine nxinit
end interface 
