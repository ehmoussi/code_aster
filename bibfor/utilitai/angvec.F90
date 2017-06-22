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

subroutine angvec(v1, v2, angle)
    implicit none
!     CALCUL DE L'ANGLE ENTRE DEUX VECTEURS EN 3D.
!     IN : V1(3)
!     IN : V2(3)
!     OUT : ANGLE
!     ATTENTION L'ORDRE V1, V2 EST IMPORTANT POUR LE SIGNE DE ANGLE
!     L'ANGLE RETOURNE EST COMPRIS ENTRE -PI ET PI (ATAN2)
!
#include "asterfort/normev.h"
#include "asterfort/provec.h"
    real(kind=8) :: v1(3), v2(3), angle, cosphi, sinphi, v1v2(3), nv1, nv2
    real(kind=8) :: norm(3), nv3
    integer :: i
!
    call normev(v1, nv1)
    call normev(v2, nv2)
    cosphi = 0.d0
    do 10 i = 1, 3
        cosphi = cosphi + v1(i)*v2(i)
10  end do
    call provec(v1, v2, norm)
    call normev(norm, nv3)
    call provec(v1, v2, v1v2)
    sinphi = 0.d0
    do 20 i = 1, 3
        sinphi = sinphi + norm(i)*v1v2(i)
20  end do
    angle= atan2(sinphi,cosphi)
end subroutine
