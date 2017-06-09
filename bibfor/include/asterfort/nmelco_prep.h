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
    subroutine nmelco_prep(phase    , calc_type,&
                           mesh     , model    , mate     , ds_contact,&
                           disp_prev, vite_prev, acce_prev, vite_curr , disp_cumu_inst,&
                           nbin     , lpain    , lchin    ,&
                           option   , time_prev, time_curr , ds_constitutive,&
                           ccohes_  , xcohes_)
        use NonLin_Datastructure_type
        character(len=4), intent(in) :: phase
        character(len=4), intent(in) :: calc_type
        character(len=8), intent(in) :: mesh
        character(len=24), intent(in) :: model
        character(len=24), intent(in) :: mate
        type(NL_DS_Contact), intent(in) :: ds_contact
        character(len=19), intent(in) :: disp_prev
        character(len=19), intent(in) :: vite_prev
        character(len=19), intent(in) :: acce_prev
        character(len=19), intent(in) :: vite_curr
        character(len=19), intent(in) :: disp_cumu_inst
        integer, intent(in) :: nbin
        character(len=8), intent(out) :: lpain(nbin)
        character(len=19), intent(out) :: lchin(nbin)
        character(len=16), intent(out) :: option
        character(len=19), intent(in) :: time_prev
        character(len=19), intent(in) :: time_curr
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        character(len=19), optional, intent(out) :: ccohes_
        character(len=19), optional, intent(out) :: xcohes_
    end subroutine nmelco_prep
end interface
