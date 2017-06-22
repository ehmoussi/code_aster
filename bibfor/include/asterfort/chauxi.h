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
    subroutine chauxi(ndim, mu, ka, r, t,&
                      invp, lcour, courb, du1dm, du2dm,&
                      du3dm, u1l, u2l, u3l)
        integer :: ndim
        real(kind=8) :: mu
        real(kind=8) :: ka
        real(kind=8) :: r
        real(kind=8) :: t
        real(kind=8) :: invp(3, 3)
        aster_logical :: lcour
        real(kind=8) :: courb(3, 3, 3)
        real(kind=8) :: du1dm(3, 3)
        real(kind=8) :: du2dm(3, 3)
        real(kind=8) :: du3dm(3, 3)
        real(kind=8) :: u1l(3)
        real(kind=8) :: u2l(3)
        real(kind=8) :: u3l(3)
    end subroutine chauxi
end interface
