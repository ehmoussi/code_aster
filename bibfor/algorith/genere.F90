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

subroutine genere(r, dim, v, x)
    implicit none
!       POUR CHAQUE POINT DE LA DISCRETISATION FREQUENTIELLE CALCULE
!                   V = R*X
! ----------------------------------------------------------------------
#include "jeveux.h"
#include "asterc/getran.h"
#include "asterc/r8pi.h"
    integer :: dim, i, j
    real(kind=8) :: u, pi
    complex(kind=8) :: r(dim, dim), v(dim), phi, x(dim)
!     -----------------------------------------------------------------
    pi =r8pi()
    do 10 i = 1, dim
!
        call getran(u)
        u = u * 2.d0 * pi
        phi = dcmplx(0.d0,u)
        x(i) = exp(phi)
        v(i) = dcmplx(0.d0,0.d0)
10  end do
    do 20 i = 1, dim
        do 30 j = 1, dim
            v(i) = v(i) + r(i,j)*x(j)
30      continue
20  end do
end subroutine
