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

subroutine xnormv(dime, xx, norme)
    implicit none
#include "blas/ddot.h"
    integer ::  dime
    real(kind=8) :: xx(dime)
    real(kind=8) :: norme
!     BUT : NORME UN VECTEUR DE R3 ET RETOURNE SA NORME INITIALE
!     RQUE : SI LA NORME EST NULLE, LE VECTEUR XX N'EST PAS NORME
! ======================================================================
!
    integer ::  j
! ======================================================================
    norme = ddot(dime, xx, 1, xx, 1)
    if (norme .ne. 0.0d0) then
        norme = dsqrt(norme)
        do j=1,dime
          xx(j) = xx(j)/norme
        enddo
    endif
end subroutine
