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
    subroutine prelog(ndim, lgpg, vim, gn, lamb,&
                      logl, fm, fp, epsml, deps,&
                      tn, resi, iret)
        integer :: lgpg
        integer :: ndim
        real(kind=8) :: vim(lgpg)
        real(kind=8) :: gn(3, 3)
        real(kind=8) :: lamb(3)
        real(kind=8) :: logl(3)
        real(kind=8) :: fm(3, 3)
        real(kind=8) :: fp(3, 3)
        real(kind=8) :: epsml(6)
        real(kind=8) :: deps(6)
        real(kind=8) :: tn(6)
        aster_logical :: resi
        integer :: iret
    end subroutine prelog
end interface
