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

subroutine angvx(gx, alpha, beta)
    implicit none
!       CALCUL DE 2 ANGLES NAUTIQUES A PARTIR DU VECTEUR GX
!       IN      GX
!       OUT     ALPHA , BETA
!       ----------------------------------------------------------------
#include "asterc/r8miem.h"
    real(kind=8) :: gx(3), alpha, beta, p, tst
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    tst = r8miem()
!
    if (abs(gx(2)) .le. tst .and. abs(gx(1)) .le. tst) then
        alpha = 0.d0
    else
        alpha = atan2(gx(2),gx(1))
    endif
    p = sqrt( gx(1)*gx(1) + gx(2)*gx(2) )
    if (abs(gx(3)) .le. tst .and. abs(p) .le. tst) then
        beta = 0.d0
    else
        beta = - atan2(gx(3),p)
    endif
end subroutine
