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

subroutine xmafr1(ndim, nd, p)
!
! person_in_charge: samuel.geniaut at edf.fr
!
    implicit none
#include "jeveux.h"
    real(kind=8) :: nd(3), p(3, 3)
    integer :: ndim
! ----------------------------------------------------------------------
!        CALCUL DE LA MATRICE DE L'OPÉRATEUR DE PROJECTION
!
! IN    NDIM : DIMENSION DU MAILLAGE
! IN    ND   : NORMALE
!
! OUT   P    : OPÉRATEUR DE PROJECTION
!
!
!
!
!
    integer :: i, j
!
!     P : OPÉRATEUR DE PROJECTION
    do 10 i = 1, ndim
        do 20 j = 1, ndim
            p(i,j) = -1.d0 * nd(i)*nd(j)
20      continue
10  end do
!
    do 30 i = 1, ndim
        p(i,i) = 1.d0 + p(i,i)
30  end do
!
end subroutine
