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

subroutine cdatrc(vr, xsi, coefcd, cd)
    implicit none
!
#include "jeveux.h"
#include "asterc/r8pi.h"
#include "asterfort/routhc.h"
    real(kind=8) :: vr, xsi, coefcd(1, 11), cd
!
    integer :: ior
    real(kind=8) :: dcldy, cd0, a0(2), dr(2)
    real(kind=8) :: pi, hr, hi, xcor, omr
    complex(kind=8) :: pr
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    ior = 2
    pi = r8pi()
    cd0 = coefcd(1,1)
    dcldy = coefcd(1,2)
    a0(1) = coefcd(1,3)
    dr(1) = coefcd(1,4)
    a0(2) = coefcd(1,5)
    dr(2) = coefcd(1,6)
!
    xcor = dble(sqrt(1.0d0-xsi*xsi))
    omr = 2.0d0*pi/vr
    pr = dcmplx(-xsi,xcor)*omr
    call routhc(hr, hi, pr, a0, dr,&
                ior)
    cd = (dcldy*hi/(omr*xcor)-cd0)
!
end subroutine
