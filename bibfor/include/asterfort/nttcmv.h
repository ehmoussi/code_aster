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
    subroutine nttcmv(model , mate  , cara_elem, list_load, nume_dof,&
                      solver, time  , tpsthe   , tpsnp1   , reasvt  ,&
                      reasmt, creas , vtemp    , vtempm   , vec2nd  ,&
                      matass, maprec, cndirp   , cnchci   , cnchtp)
        character(len=24), intent(in) :: model
        character(len=24), intent(in) :: mate
        character(len=24), intent(in) :: cara_elem
        character(len=19), intent(in) :: list_load
        character(len=24), intent(in) :: nume_dof
        character(len=19), intent(in) :: solver
        character(len=24), intent(in) :: time
        real(kind=8) :: tpsthe(6)
        real(kind=8) :: tpsnp1
        aster_logical :: reasvt
        aster_logical :: reasmt
        character(len=1) :: creas
        character(len=24) :: vtemp
        character(len=24) :: vtempm
        character(len=24) :: vec2nd
        character(len=24) :: matass
        character(len=19) :: maprec
        character(len=24) :: cndirp
        character(len=24) :: cnchci
        character(len=24) :: cnchtp
    end subroutine nttcmv
end interface
