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

function rminsp(x1, x2, x3, x4, x5)
    implicit   none
#include "asterfort/assert.h"
    real(kind=8) :: rminsp, x1, x2, x3, x4, x5, xmin
!      CALCULER LE "MIN" DE 5 VALEURS >=0. EN NE TENANT
!      COMPTE QUE DES VALEURS NON NULLES
!
! IN  : X1,X2,X3,X4,X5 : 5 REELS >= 0.D0
! OUT : RMINSP : LE "MIN" DES X1, ..., X5 NON NULS
! REMARQUE : X1 DOIT ETRE > 0
!     ------------------------------------------------------------------
!
! DEB------------------------------------------------------------------
    ASSERT(x1.gt.0.d0)
    ASSERT(x2.ge.0.d0)
    ASSERT(x3.ge.0.d0)
    ASSERT(x4.ge.0.d0)
    ASSERT(x5.ge.0.d0)
!
    xmin=x1
    if (x2 .gt. 0.d0 .and. x2 .lt. xmin) xmin=x2
    if (x3 .gt. 0.d0 .and. x3 .lt. xmin) xmin=x3
    if (x4 .gt. 0.d0 .and. x4 .lt. xmin) xmin=x4
    if (x5 .gt. 0.d0 .and. x5 .lt. xmin) xmin=x5
!
    rminsp=xmin
!
end function
