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
#include "asterf_types.h"
!
interface
    subroutine nxnewt(model    , mate       , cara_elem  , list_load, nume_dof ,&
                      solver   , tpsthe     , time       , matass   , cn2mbr   ,&
                      maprec   , cnchci     , varc_curr  , temp_prev, temp_iter,&
                      vtempp   , vec2nd     , mediri     , conver   , hydr_prev,&
                      hydr_curr, dry_prev   , dry_curr   , compor   , cnvabt   ,&
                      cnresi   , ther_crit_i, ther_crit_r, reasma   , testr    ,&
                      testm    , vnorm, ds_algorom)
        use ROM_Datastructure_type
        character(len=24), intent(in) :: model
        character(len=24), intent(in) :: mate
        character(len=24), intent(in) :: cara_elem
        character(len=19), intent(in) :: list_load
        character(len=24), intent(in) :: nume_dof
        character(len=19), intent(in) :: solver
        real(kind=8) :: tpsthe(6)
        character(len=24), intent(in) :: time
        character(len=19), intent(in) :: varc_curr
        character(len=24) :: matass
        character(len=19) :: maprec
        character(len=24) :: cnchci
        character(len=24) :: cn2mbr
        character(len=24) :: temp_prev
        character(len=24) :: temp_iter
        character(len=24) :: vtempp
        character(len=24) :: vec2nd
        character(len=24) :: mediri
        aster_logical :: conver
        character(len=24) :: hydr_prev
        character(len=24) :: hydr_curr
        character(len=24) :: dry_prev
        character(len=24) :: dry_curr
        character(len=24) :: compor
        character(len=24) :: cnvabt
        character(len=24) :: cnresi
        integer :: ther_crit_i(*)
        real(kind=8) :: ther_crit_r(*)
        aster_logical :: reasma
        real(kind=8) :: testr
        real(kind=8) :: testm
        real(kind=8) :: vnorm
        type(ROM_DS_AlgoPara), intent(in) :: ds_algorom
    end subroutine nxnewt
end interface
