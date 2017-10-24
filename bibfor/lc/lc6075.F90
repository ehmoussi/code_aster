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

subroutine lc6075(fami, kpg, ksp, ndim, imate,&
                    compor, carcri, instam, instap, neps, &
                    epsm, deps, nsig, sigm, nvi, &
                    vim, option, angmas, sigp, vip, &
                    typmod, icomp, ndsde, dsidep, codret)

!
!
! aslint: disable=W1504,W0104

    implicit none
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/lcgtn_wrap.h"
    
    
    integer      :: imate, ndim, kpg, ksp, codret, icomp
    integer      :: nvi,neps,nsig,ndsde
    real(kind=8) :: carcri(*), angmas(*)
    real(kind=8) :: instam, instap
    real(kind=8) :: epsm(*), deps(*)
    real(kind=8) :: sigm(*), sigp(*)
    real(kind=8) :: vim(*), vip(*)
    real(kind=8) :: dsidep(*)
    character(len=16) :: compor(*), option
    character(len=8) :: typmod(*)
    character(len=*) :: fami
! ----------------------------------------------------------------------
!  Loi de comportement GTN
! ----------------------------------------------------------------------
    aster_logical,parameter:: grvi=.true.
! ----------------------------------------------------------------------
        ASSERT (neps .eq. nint(sqrt(float(ndsde))))
        ASSERT (neps .eq. nsig)

        call lcgtn_wrap(fami, kpg, ksp, ndim, imate,&
                    carcri, instam, instap, neps, epsm, &
                    deps, vim, option, sigp, vip, &
                    grvi, dsidep, codret)

end subroutine
