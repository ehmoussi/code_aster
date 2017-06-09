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

subroutine routhc(hr, hi, pr, a0, dr,&
                  ior)
    implicit none
!
#include "jeveux.h"
    integer :: ior
    real(kind=8) :: hr, hi, a0(*), dr(*)
    complex(kind=8) :: pr
!
    complex(kind=8) :: h, z
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: i
!-----------------------------------------------------------------------
    h = dcmplx ( 1.0d0, 0.0d0 )
    do 1 i = 1, ior
        z = a0(i)/(pr+dr(i))
        h = h - pr*z
 1  end do
    hr = dble(h)
    hi = dimag(h)
!
end subroutine
