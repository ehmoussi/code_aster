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

subroutine orien1(xp, xq, angl)
    implicit none
#include "asterc/r8pi.h"
#include "asterfort/utmess.h"
    real(kind=8) :: xp(*), xq(*), angl(*)
!     ORIENTATION D'UN AXE(XQ,XP) DEFINI PAR DEUX POINTS
! ----------------------------------------------------------------------
! IN  : XP     : EXTREMITE INITIALE DE L'AXE
! IN  : XQ     : EXTREMITE FINALE DE L'AXE
! OUT : A B G  : ANGLES D'ORIENTATION DE L'AXE
! ----------------------------------------------------------------------
!-----------------------------------------------------------------------
    real(kind=8) :: d, pi, r, s, t, zero
!
!-----------------------------------------------------------------------
    pi = r8pi()
    zero = 0.d0
!
    r = xq(1) - xp(1)
    s = xq(2) - xp(2)
    t = xq(3) - xp(3)
    d = sqrt( r*r + s*s )
!
    angl(3) = zero
    if (d .ne. zero) then
        angl(1) = atan2(s,r)
        angl(2) = -atan2(t,d)
    else
        angl(1) = zero
        if (t .eq. zero) then
            call utmess('F', 'UTILITAI3_39')
        else if (t .lt. zero) then
            angl(2) = pi / 2.d0
        else
            angl(2) = -pi / 2.d0
        endif
    endif
!
end subroutine
