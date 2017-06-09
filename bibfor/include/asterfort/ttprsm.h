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
    subroutine ttprsm(ndim, ddeple, ddeplm, dlagrf, coeffr,&
                      tau1, tau2, mprojt, inadh, rese,&
                      nrese, coeffp, lpenaf, dvitet)
        integer :: ndim
        real(kind=8) :: ddeple(3)
        real(kind=8) :: ddeplm(3)
        real(kind=8) :: dlagrf(2)
        real(kind=8) :: coeffr
        real(kind=8) :: tau1(3)
        real(kind=8) :: tau2(3)
        real(kind=8) :: mprojt(3, 3)
        integer :: inadh
        real(kind=8) :: rese(3)
        real(kind=8) :: nrese
        real(kind=8) :: coeffp
        aster_logical :: lpenaf
        real(kind=8) :: dvitet(3)
    end subroutine ttprsm
end interface
