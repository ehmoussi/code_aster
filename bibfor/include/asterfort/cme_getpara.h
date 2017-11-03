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
interface
    subroutine cme_getpara(option      ,&
                           model       , cara_elem, mate, compor_mult,&
                           v_list_load8, nb_load  ,&
                           rigi_meca   , mass_meca,&
                           time_curr   , time_incr, nh       ,&
                           sigm        , strx     , disp)
        character(len=16), intent(out) :: option
        character(len=8), intent(out) :: model
        character(len=8), intent(out) :: cara_elem
        character(len=24), intent(out) :: mate
        character(len=24), intent(out) :: compor_mult
        character(len=8), intent(out), pointer :: v_list_load8(:)
        integer, intent(out) :: nb_load
        character(len=19), intent(out) :: rigi_meca
        character(len=19), intent(out) :: mass_meca
        real(kind=8), intent(out) :: time_curr
        real(kind=8), intent(out) :: time_incr
        integer, intent(out) :: nh
        character(len=8), intent(out) :: sigm
        character(len=8), intent(out) :: strx
        character(len=8), intent(out) :: disp
    end subroutine cme_getpara
end interface
