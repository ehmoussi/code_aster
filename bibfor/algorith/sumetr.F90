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

subroutine sumetr(cova, metr, jac)
!
    implicit none
!
#include "blas/ddot.h"
    real(kind=8) :: cova(3, 3), metr(2, 2), jac
!
!.......................................................................
!     CALCUL DU TENSEUR METRIQUE (2X2) ET DE SON JACOBIEN
!.......................................................................
! IN  COVA    COORDONNEES DES VECTEURS DE LA BASE COVARAINTE
! OUT METR    TENSEUR METRIQUE (2X2)
! OUT JAC     JACOBIEN DE LA METRIQUE
!.......................................................................
!
    integer :: i, j
!
!
!    CALCUL DE LA METRIQUE
    do 10 i = 1, 2
        do 20 j = 1, 2
            metr(i,j) = ddot(3,cova(1,i),1,cova(1,j),1)
20      continue
10  end do
!
!
!    CALCUL DU JACOBIEN
    jac = sqrt(abs( metr(1,1)*metr(2,2) - metr(1,2)*metr(2,1) ))
!
end subroutine
