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

subroutine mavec(mp, m, mv, n)
    implicit none
!       PASSAGE  MATRICE PLEINE (M*M) > DEMI-MATRICE COLONNE VECTEUR(N)
!       IN      MP = MATRICE PLEINE (M*M)
!       OUT     MV = VECTEUR DEMI - MATRICE STOCKE COLONNE , LONGUEUR N
!       ----------------------------------------------------------------
#include "asterfort/assert.h"
    integer :: m, n
    real(kind=8) :: mv(n), mp(m, m)
!
!-----------------------------------------------------------------------
    integer :: i, j, k
!-----------------------------------------------------------------------
    ASSERT(n.ge.m*(m+1)/2)
!
    k = 0
    do 10 i = 1, m
        do 20 j = 1, m
            k = k + 1
            mv(k) = mp(i,j)
            if (j .eq. i) goto 10
20      continue
10  continue
!
end subroutine
