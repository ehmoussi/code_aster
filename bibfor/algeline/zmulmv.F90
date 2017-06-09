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

subroutine zmulmv(trans, m, n, alpha, a,&
                  lda, x, incx, beta, y,&
                  incy)
    implicit none
#include "asterfort/vecinc.h"
#include "asterfort/zmult.h"
#include "blas/zaxpy.h"
#include "blas/zdotc.h"
#include "blas/zdotu.h"
    integer :: m, n, lda, incx, incy
    complex(kind=8) :: alpha, beta, x(*), y(*)
    character(len=*) :: trans
!  CALCUL DU PRODUIT D'UNE MATRICE PAR UN VECTEUR (OPTION 'N' 'T' 'C').
!-----------------------------------------------------------------------
! IN  : TRANS: CARACTERE SPECIFIANT L'OPERATION A REALISER.
!                 TRANS               OPERATION
!              'N'             Y = ALPHA*A*X + BETA*Y
!              'T'             Y = ALPHA*A'*X + BETA*Y
!              'C'             Y = ALPHA*CONJG(A)'*X + BETA*Y
!     : M    : NOMBRE DE LIGNES DE A.
!     : N    : NOMBRE DE COLONNES DE A.
!     : ALPHA: SCALAIRE.
!     : A    : MATRICE COMPLEXE DE DIMENSION M*N
!     : LDA  : DIMENSION DE A
!     : X    : VECTEUR COMLEXE DE LONGUEUR (N-1)*IABS(INCX)+1 LORSQUE
!              TRANS EST EGAL A 'N' ET DE LONGUEUR (M-1)*IABS(INCX)+1
!              SINON.
!     : INCX : DEPLACEMENT ENTRE LES ELEMENTS DE X.
!     : BETA : COMPLEXE.'LORSQUE BETA EGAL ZERO, Y EST NON CALCULE.
! I/O : Y    :  (N-1)*IABS(INCY)+1
!               (M-1)*IABS(INCY)+1
! OUT : INCY : DEPLACEMENT ENTRE LES ELEMENTS DE Y.
!-----------------------------------------------------------------------
!                                  SPECIFICATIONS FOR LOCAL VARIABLES
    integer :: i, ix, iy, ky, lenx, leny
    complex(kind=8) :: a(*)
    integer :: kx
!
    if (m .eq. 0 .or. n .eq. 0 .or. alpha .eq. (0.0d0,0.0d0) .and. beta .eq. (1.0d0,0.0d0)) &
    goto 999
!
    if (trans(1:1) .eq. 'N' .or. trans(1:1) .eq. 'n') then
        lenx = n
        leny = m
    else
        lenx = m
        leny = n
    endif
!
    ix = 1
    iy = 1
    if (incx .lt. 0) ix = (-lenx+1)*incx + 1
    if (incy .lt. 0) iy = (-leny+1)*incy + 1
!
    if (beta .eq. (1.0d0,0.0d0)) then
    else if (incy .eq. 0) then
        if (beta .eq. (0.0d0,0.0d0)) then
            y(1) = (0.0d0,0.0d0)
        else
            y(1) = beta**leny*y(1)
        endif
    else if (beta .eq. (0.0d0,0.0d0)) then
        call vecinc(leny, (0.0d0, 0.0d0), y, inc=abs(incy))
    else
        call zmult(leny, beta, y, abs(incy))
    endif
!
    if (alpha .eq. (0.0d0,0.0d0)) goto 999
!
    if (trans(1:1) .eq. 'N' .or. trans(1:1) .eq. 'n') then
        kx = ix
        do 10 i = 1, n
            call zaxpy(m, alpha*x(kx), a(lda*(i-1)+1), 1, y,&
                       incy)
            kx = kx + incx
10      continue
    else if (trans(1:1).eq.'T' .or. trans(1:1).eq.'t') then
!
        ky = iy
        do 20 i = 1, n
            y(ky) = y(ky) + alpha*zdotu(m,a(lda*(i-1)+1),1,x,incx)
            ky = ky + incy
20      continue
!
    else
        ky = iy
        do 30 i = 1, n
            y(ky) = y(ky) + alpha*zdotc(m,a(lda*(i-1)+1),1,x,incx)
            ky = ky + incy
30      continue
    endif
!
999  continue
end subroutine
