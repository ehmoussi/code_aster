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

function r8sqrt(a, b)
    implicit none
    real(kind=8) :: a, b
!     CALCUL DE SQRT(A**2+B**2) SANS UNDER OU OVERFLOW
!-----------------------------------------------------------------------
! IN  : A    : PREMIER PARAMETRE.
!     : B    : SECOND PARAMETRE.
! OUT : HYPOT: SQRT(A**2+B**2).
!-----------------------------------------------------------------------
    real(kind=8) :: p, r, s, t, u
!
!-----------------------------------------------------------------------
    real(kind=8) :: r8sqrt
!-----------------------------------------------------------------------
    p = max(abs(a),abs(b))
    if (p .eq. 0.0d0) goto 20
    r = (min(abs(a),abs(b))/p)**2
10  continue
    t = 4.0d0 + r
    if (t .eq. 4.0d0) goto 20
    s = r/t
    u = 1.0d0 + 2.0d0*s
    p = u*p
    r = (s/u)**2*r
    goto 10
20  continue
    r8sqrt = p
end function
