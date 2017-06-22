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
! aslint: disable=W1504
!
interface
    subroutine nxrech(model    , mate    , cara_elem, list_load  , nume_dof   ,&
                      tpsthe   , time    , lonch    , compor     , varc_curr  ,&
                      temp_iter, vtempp  , vtempr   , temp_prev  , hydr_prev  ,&
                      hydr_curr, dry_prev, dry_curr , vec2nd     , cnvabt     ,&
                      cnresi   , rho     , iterho   , ds_algopara)
        use NonLin_Datastructure_type
        character(len=24), intent(in) :: model
        character(len=24), intent(in) :: mate
        character(len=24), intent(in) :: cara_elem
        character(len=19), intent(in) :: list_load
        character(len=24), intent(in) :: nume_dof
        real(kind=8) :: tpsthe(6)
        character(len=24), intent(in) :: time
        character(len=19), intent(in) :: varc_curr
        type(NL_DS_AlgoPara), intent(in) :: ds_algopara
        integer :: lonch
        character(len=24) :: compor
        character(len=24) :: vtempp
        character(len=24) :: vtempr
        character(len=24) :: temp_prev
        character(len=24) :: temp_iter
        character(len=24) :: hydr_prev
        character(len=24) :: hydr_curr
        character(len=24) :: dry_prev
        character(len=24) :: dry_curr
        character(len=24) :: vec2nd
        character(len=24) :: cnvabt
        character(len=24) :: cnresi
        real(kind=8) :: rho
        integer :: iterho
    end subroutine nxrech
end interface
