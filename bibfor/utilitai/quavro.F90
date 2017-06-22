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

subroutine quavro(quater, theta)
!
!
! aslint: disable=
    implicit none
#include "asterc/r8prem.h"
#include "asterc/r8pi.h"
#include "blas/ddot.h"
    real(kind=8) :: quater(4), theta(3)
!
! ----------------------------------------------------------------------
!
! ROUTINE UTILITAIRE (QUATERNION)
!
! CALCULE LE VECTEUR-ROTATION THETA CORRESPONDANT AU QUATERNION
! QUATER
!
! ----------------------------------------------------------------------
!
!
! IN  QUATER : QUATERNION
! OUT THETA  : VECTEUR ROTATION
!
! ----------------------------------------------------------------------
!
    real(kind=8) :: reste, zero, epsil, deux, coef
    real(kind=8) :: pi
    real(kind=8) :: prosca, anorx
    integer :: i
!
! ----------------------------------------------------------------------
!C
    zero = 0.d0
    epsil = r8prem( )**2
    deux = 2.d0
    pi = r8pi()
!
    prosca = ddot(3,quater,1,quater,1)
    anorx = sqrt(prosca)
    if (anorx .gt. 1.d0) anorx = 1.d0
    if (anorx .lt. epsil) then
        do 1 i = 1, 3
            theta(i) = zero
 1      continue
        goto 9999
    endif
    reste = asin(anorx)
!
    if (quater(4) .lt. zero) reste = pi - reste
!
    coef = deux*reste/anorx
!
    do 10 i = 1, 3
        theta(i) = coef * quater(i)
10  end do
9999  continue
end subroutine
