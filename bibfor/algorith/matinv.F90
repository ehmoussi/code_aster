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

subroutine matinv(stop, ndim, mat, inv, det)
!
    implicit none
!
#include "asterc/r8gaem.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
!
! aslint: disable=W1306
!
    character(len=1), intent(in) :: stop
    integer, intent(in) :: ndim
    real(kind=8), intent(in) :: mat(ndim, ndim)
    real(kind=8), intent(out) :: inv(ndim, ndim)
    real(kind=8), intent(out) :: det
!
! ----------------------------------------------------------------------
!
! MATRICE - CALCUL DE SON INVERSE (DIM = 1 , 2 OU 3)
!
! ----------------------------------------------------------------------
!
! IN  STOP   : /'S' : ON S'ARRETE EN ERREUR <F> EN CAS D'ECHEC
!              /'C' : ON CONTINUE EN CAS D'ECHEC (SI LA VALEUR ABS DU
!                     DETERMINANT EST INFERIEURE A LA PRECISION MACHINE)
!                     ET ON MET DET = 0
! IN  NDIM   : DIMENSION DE LA MATRICE
! IN  MAT    : MATRICE A INVERSER
! OUT INV    : MATRICE INVERSE
! OUT DET    : DETERMINANT DE LA MATRICE MAT
!
! ----------------------------------------------------------------------
!
    integer :: idim, jdim
    real(kind=8) :: m(ndim, ndim), unsdet
!
    if (ndim .eq. 1) then
!
        m(1,1) = 1.d0
        det = mat(1,1)
!
    else if (ndim.eq.2) then
!
! --- CALCUL DES (-1)^(I+J)*MINEURS(J,I)
!
        m(1,1) = mat(2,2)
        m(2,1) = - mat(2,1)
        m(1,2) = - mat(1,2)
        m(2,2) = mat(1,1)
!
! ---   CALCUL DU DETERMINANT
!
        det = mat(1,1)*mat(2,2) - mat(1,2)*mat(2,1)
!
    else if (ndim.eq.3) then
!
! --- CALCUL DES (-1)^(I+J)*MINEURS(J,I)
!
        m(1,1) = mat(2,2) * mat(3,3) - mat(2,3) * mat(3,2)
        m(2,1) = mat(3,1) * mat(2,3) - mat(2,1) * mat(3,3)
        m(3,1) = mat(2,1) * mat(3,2) - mat(3,1) * mat(2,2)
        m(1,2) = mat(1,3) * mat(3,2) - mat(1,2) * mat(3,3)
        m(2,2) = mat(1,1) * mat(3,3) - mat(1,3) * mat(3,1)
        m(3,2) = mat(1,2) * mat(3,1) - mat(3,2) * mat(1,1)
        m(1,3) = mat(1,2) * mat(2,3) - mat(1,3) * mat(2,2)
        m(2,3) = mat(2,1) * mat(1,3) - mat(2,3) * mat(1,1)
        m(3,3) = mat(1,1) * mat(2,2) - mat(1,2) * mat(2,1)
!
! ---   CALCUL DU DETERMINANT
!
        det = mat(1,1)*m(1,1) + mat(1,2)*m(2,1) + mat(1,3)*m(3,1)
    else
        ASSERT(.false.)
    endif
!
    if (abs(det) .le. 1.d0/r8gaem()) then
        if (stop .eq. 'S') then
            call utmess('F', 'ALGORITH5_19')
        else if (stop.eq.'C') then
            det = 0.d0
            goto 999
        else
            ASSERT(.false.)
        endif
    endif
!
! --- CALCUL DE L'INVERSE
!
    unsdet = 1.d0/det
    do jdim = 1, ndim
        do idim = 1, ndim
            inv(idim,jdim) = unsdet * m(idim,jdim)
        enddo
    enddo
!
999  continue
end subroutine
