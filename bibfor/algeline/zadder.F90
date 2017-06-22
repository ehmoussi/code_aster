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

subroutine zadder(uplo, n, alpha, x, incx,&
                  a, lda)
    implicit none
#include "asterf_types.h"
#include "blas/zaxpy.h"
    integer :: n, incx, lda
    real(kind=8) :: alpha
    complex(kind=8) :: x(*), a(*)
    character(len=*) :: uplo
!    CALCUL DE ALPHA*X*CONJG(X)'  =>    A MATRICE HERMITIENNE.
!-----------------------------------------------------------------------
! IN  : UPLO : INDIQUE LE MODE DE STOCKAGE DE LA MATRICE.
!              SI UPLO EST 'U' ALORS SEULEMENT LA PARTIE SUPERIEURE DE A
!              EST UTILISEE. SI UPLO EST 'L', ALORS LA PARTIE INFERIEURE
!              EST UTILISEE.
!     : N    : DIMENSION DE LA MATRICE A.
!     : ALPHA: SCALAIRE.
!     : X    : DVECTEURE COMPLEXE DE LONGUEUR (N-1)*IABS(INCX)+1.
!     : INCX : DEPLACEMENT ENTRE LES ELEMENTS DE X.
! I/O : A    : MATRICE COMPLEXE DE DIMENSION N.
! IN  : LDA  : DIMENSION DE A.
!-----------------------------------------------------------------------
    integer :: ix, j
    complex(kind=8) :: temp, temp1, temp2, temp3, temp4
    aster_logical :: upper
    real(kind=8) :: dble
!
    if (n .eq. 0 .or. alpha .eq. 0.0d0) goto 9000
!
    ix = 1
    if (incx .lt. 0) ix = (-n+1)*incx + 1
!
    upper = (uplo(1:1).eq.'U') .or. (uplo(1:1).eq.'u')
!
    do 10 j = 1, n
        temp = alpha*dconjg(x(ix))
        if (upper) then
            if (incx .ge. 0) then
                call zaxpy(j-1, temp, x, incx, a(lda*(j-1)+1),&
                           1)
            else
                call zaxpy(j-1, temp, x(ix-incx), incx, a(lda*(j-1)+ 1),&
                           1)
            endif
        else
            if (incx .ge. 0) then
                call zaxpy(n-j, temp, x(ix+incx), incx, a(lda*(j-1)+ j+1),&
                           1)
            else
                call zaxpy(n-j, temp, x, incx, a(lda*(j-1)+j+1),&
                           1)
            endif
        endif
        temp1 = a(lda*(j-1)+j)
        temp2 = x(ix)*temp
        temp3 = dble(temp1)
        temp4 = dble(temp2)
        a(lda*(j-1)+j) = temp3 + temp4
        ix = ix + incx
 10 end do
!
9000 continue
    goto 9999
9999 continue
end subroutine
