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

subroutine zmult(n, za, zx, incx)
    implicit none
    integer :: n, incx
    complex(kind=8) :: za, zx(*)
!    CALCUL DE Y = A*X POUR DES VECTEURS COMPLEXES
!-----------------------------------------------------------------------
! IN  : N    : LONGUEUR DU VECTEUR X.
!     : ZA   : COMPLEXE.
! I/O : ZX   : VECTEUR COMPLEXE DE LONGUEUR MAX(N*IABS(INCX),1).
!              ZMULT REMPLACE X(I) PAR ZA*X(I) POUR I = 1,...,N.
! IN  : INCX : DEPLACEMENT ENTRE LES ELEMENTS DE ZX.
!              X(I) EST DEFINI PAR ZX(1+(I-1)*INCX). INCX DOIT ETRE
!              PLUS GRAND QUE ZERO.
!-----------------------------------------------------------------------
    integer :: i, ix
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    if (n .gt. 0) then
        if (incx .ne. 1) then
!
            ix = 1
            if (incx .lt. 0) ix = (-n+1)*incx + 1
            do 10 i = 1, n
                zx(ix) = za*zx(ix)
                ix = ix + incx
10          continue
        else
!
            do 20 i = 1, n
                zx(i) = za*zx(i)
20          continue
        endif
    endif
end subroutine
