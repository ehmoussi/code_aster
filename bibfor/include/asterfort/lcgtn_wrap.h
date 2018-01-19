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

#include "asterf_types.h"

interface
    subroutine lcgtn_wrap(fami, kpg, ksp, ndim, imate, &
                      crit, instam, instap, neps, epsm, &
                      deps, vim, option, sigp, vip, &
                      grvi, dsidep, codret)
        character(len=*) :: fami
        integer :: kpg
        integer :: ksp
        integer :: ndim
        integer :: imate
        real(kind=8) :: crit(*)
        real(kind=8) :: instam
        real(kind=8) :: instap
        integer :: neps
        real(kind=8) :: epsm(neps)
        real(kind=8) :: deps(neps)
        real(kind=8) :: vim(*)
        character(len=16) :: option
        real(kind=8) :: sigp(neps)
        real(kind=8) :: vip(*)
        aster_logical:: grvi
        real(kind=8) :: dsidep(neps,neps)
        integer :: codret
    end subroutine lcgtn_wrap
end interface
