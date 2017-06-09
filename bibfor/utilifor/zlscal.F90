! --------------------------------------------------------------------
! Copyright (C) BLAS
! Copyright (C) 2007 - 2017 - EDF R&D - www.code-aster.org
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

subroutine zlscal(n, za, zx, incx)
!     SCALES A VECTOR BY A CONSTANT.
!     JACK DONGARRA, 3/11/78.
!     MODIFIED 3/93 TO RETURN IF INCX .LE. 0.
!     MODIFIED 12/3/93, ARRAY(1) DECLARATIONS CHANGED TO ARRAY(*)
! ======================================================================
! REMPLACE LA BLAS ZSCAL SUR LES MACHINES OU ELLE N'EST PAS DISPONIBLE
! DANS LES LIBRAIRIES SYSTEME
!-----------------------------------------------------------------------
! CORPS DU PROGRAMME
    implicit none
!
    complex(kind=8) :: za, zx(*)
    integer :: i, incx, ix, n
!
    if (n .le. 0 .or. incx .le. 0) goto 9999
    if (incx .eq. 1) goto 20
!
!        CODE FOR INCREMENT NOT EQUAL TO 1
!
    ix = 1
    do 10 i = 1, n
        zx(ix) = za*zx(ix)
        ix = ix + incx
10  end do
    goto 9999
!
!        CODE FOR INCREMENT EQUAL TO 1
!
20  continue
    do 30 i = 1, n
        zx(i) = za*zx(i)
30  end do
9999  continue
end subroutine
