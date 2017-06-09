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

subroutine marota(tetag, drot)
!
! FONCTION: CALCULE LA MATRICE DE ROTATION 'DROT' CORRESPONDANT AU
!           VECTEUR-ROTATION 'TETAG'
!
!     IN  : TETAG     : VECTEUR D'ORDRE 3
!
!     OUT : DROT      : MATRICE ORTHOGONALE D'ORDRE 3
! ------------------------------------------------------------------
    implicit none
#include "asterc/r8prem.h"
#include "asterfort/antisy.h"
#include "blas/ddot.h"
    real(kind=8) :: tetag(3), drot(3, 3), amat1(3, 3), amat2(3, 3)
!
!-----------------------------------------------------------------------
    integer :: i, j
    real(kind=8) :: coef, coef1, coef2, epsil, teta1
    real(kind=8) :: teta2, un, zero
!-----------------------------------------------------------------------
    zero = 0.d0
    epsil = r8prem( )**4
    un = 1.d0
    teta2=ddot(3,tetag,1,tetag,1)
    if (abs(teta2) .lt. epsil) goto 30
    teta1 = sqrt (teta2)
    coef = un / teta1
    call antisy(tetag, coef, amat1)
    coef = un / teta2
    do 12 j = 1, 3
        do 11 i = 1, 3
            amat2(i,j) = coef * tetag(i) * tetag(j)
11      end do
        amat2(j,j) = amat2(j,j) - un
12  end do
    coef1 = sin(teta1)
    coef2 = un - cos(teta1)
    do 22 j = 1, 3
        do 21 i = 1, 3
            drot(i,j) = coef1*amat1(i,j) + coef2*amat2(i,j)
21      end do
        drot(j,j) = drot(j,j) + un
22  end do
    goto 40
!*** TETAG EST TRES PETIT ET LA MATRICE DROT EST PRATIQUEMENT L'UNITE
30  continue
    do 32 j = 1, 3
        do 31 i = 1, 3
            drot(i,j) = zero
31      end do
        drot(j,j) = un
32  end do
40  continue
    goto 9999
9999  continue
end subroutine
