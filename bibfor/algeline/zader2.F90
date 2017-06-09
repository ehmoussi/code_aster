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

subroutine zader2(uplo, n, alpha, x, incx,&
                  y, incy, a, lda)
    implicit none
#include "asterf_types.h"
#include "blas/zaxpy.h"
    integer :: n, incx, incy, lda
    complex(kind=8) :: alpha, x(*), y(*), a(lda, *)
    character(len=*) :: uplo
!   CALCUL DE A: MATRICE HERMITIENNE
!   A = A + ALPHA*X*CONJG(Y)' + CONJG(ALPHA)*Y*CONJG(X)'
!-----------------------------------------------------------------------
! IN  : UPLO : INDIQUE LE MODE DE STOCKAGE DE LA MATRICE.
!              SI UPLO EST 'U' ALORS SEULEMENT LA PARTIE SUPERIEURE DE A
!              EST UTILISEE. SI UPLO EST 'L', ALORS LA PARTIE INFERIEURE
!              EST UTILISEE.
!     : N    : DIMENSION DE LA MATRICE A.
!     : ALPHA: SCALAIRE.
!     : X    : DVECTEURE COMPLEXE DE LONGUEUR (N-1)*IABS(INCX)+1.
!     : INCX : DEPLACEMENT ENTRE LES ELEMENTS DE X.
!     : Y    : DVECTEURE COMPLEXE DE LONGUEUR (N-1)*IABS(INCY)+1.
!     : INCY : DEPLACEMENT ENTRE LES ELEMENTS DE Y.
! I/O : A    : MATRICE COMPLEXE DE DIMENSION N.
! IN  : LDA  : DIMENSION DE A
!-----------------------------------------------------------------------
    integer :: ix, iy, j
    complex(kind=8) :: tempx, tempy, temp1
    aster_logical :: upper
    real(kind=8) :: dble
!
    if (n .eq. 0 .or. alpha .eq. (0.0d0,0.0d0)) goto 9999
!
    ix = 1
    iy = 1
    if (incx .lt. 0) ix = 1 - (n-1)*incx
    if (incy .lt. 0) iy = 1 - (n-1)*incy
!
    upper = (uplo(1:1).eq.'U') .or. (uplo(1:1).eq.'u')
!
    do 10 j = 1, n
        tempx = dconjg(alpha*x(ix))
        tempy = alpha*dconjg(y(iy))
        if (upper) then
            if (incx .ge. 0) then
                call zaxpy(j-1, tempy, x, incx, a(1, j),&
                           1)
            else
                call zaxpy(j-1, tempy, x(ix-incx), incx, a(1, j),&
                           1)
            endif
            if (incy .ge. 0) then
                call zaxpy(j-1, tempx, y, incy, a(1, j),&
                           1)
            else
                call zaxpy(j-1, tempx, y(iy-incy), incy, a(1, j),&
                           1)
            endif
        else
            if (incx .ge. 0) then
                call zaxpy(n-j, tempy, x(ix+incx), incx, a(j+1, j),&
                           1)
            else
                call zaxpy(n-j, tempy, x, incx, a(j+1, j),&
                           1)
            endif
            if (incy .ge. 0) then
                call zaxpy(n-j, tempx, y(iy+incy), incy, a(j+1, j),&
                           1)
            else
                call zaxpy(n-j, tempx, y, incy, a(j+1, j),&
                           1)
            endif
        endif
        temp1 = a(j,j) + y(iy)*tempx + x(ix)*tempy
        a(j,j) = dble(temp1)
        ix = ix + incx
        iy = iy + incy
 10 end do
!
9999 continue
end subroutine
