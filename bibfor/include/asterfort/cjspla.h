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
#include "asterf_types.h"
!
interface
    subroutine cjspla(mod, crit, mater, seuili, seuild,&
                      nvi, epsd, deps, sigd, vind,&
                      sigf, vinf, mecani, nivcjs, niter,&
                      ndec, epscon, iret, trac)
        character(len=8) :: mod
        real(kind=8) :: crit(*)
        real(kind=8) :: mater(14, 2)
        real(kind=8) :: seuili
        real(kind=8) :: seuild
        integer :: nvi
        real(kind=8) :: epsd(6)
        real(kind=8) :: deps(6)
        real(kind=8) :: sigd(6)
        real(kind=8) :: vind(*)
        real(kind=8) :: sigf(6)
        real(kind=8) :: vinf(*)
        character(len=6) :: mecani
        character(len=4) :: nivcjs
        integer :: niter
        integer :: ndec
        real(kind=8) :: epscon
        integer :: iret
        aster_logical :: trac
    end subroutine cjspla
end interface
