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
    subroutine lcgrad(resi, rigi, ndim, ndimsi, neps,&
                      sigma, apg, lag, grad, aldc,&
                      r, c, ktg, sig, dsidep)
        integer :: neps
        integer :: ndim
        aster_logical :: resi
        aster_logical :: rigi
        integer :: ndimsi
        real(kind=8) :: sigma(6)
        real(kind=8) :: apg
        real(kind=8) :: lag
        real(kind=8) :: grad(ndim)
        real(kind=8) :: aldc
        real(kind=8) :: r
        real(kind=8) :: c
        real(kind=8) :: ktg(6, 6, 4)
        real(kind=8) :: sig(neps)
        real(kind=8) :: dsidep(neps, neps)
    end subroutine lcgrad
end interface
