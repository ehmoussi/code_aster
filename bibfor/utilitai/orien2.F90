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

subroutine orien2(xp, xq, xr, angl)
    implicit none
#include "asterfort/matrot.h"
#include "asterfort/orien1.h"
#include "asterfort/pmavec.h"
#include "asterfort/utmess.h"
    real(kind=8) :: xp(*), xq(*), xr(*), angl(*)
!     ORIENTATION D'UN TRIEDRE(XQ,XP,XR) DEFINI PAR TROIS POINTS (X,Y)
! ----------------------------------------------------------------------
! IN  : X..    : COORDONNEES DES POINTS
! OUT : A B G  : ANGLES D'ORIENTATION DE L'AXE
! ----------------------------------------------------------------------
    real(kind=8) :: xpr(3), xpq(3), xxpr(3), mro(3, 3)
! ----------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: i
    real(kind=8) :: r, s, zero
!-----------------------------------------------------------------------
    zero = 0.d0
!
    r = zero
    s = zero
    do 10 i = 1, 3
        xpq(i) = xq(i) - xp(i)
        r = r + xpq(i)*xpq(i)
        xpr(i) = xr(i) - xp(i)
        s = s + xpr(i)*xpr(i)
10  end do
    if (r .eq. zero) then
        call utmess('F', 'UTILITAI3_39')
    endif
    if (s .eq. zero) then
        call utmess('F', 'UTILITAI3_39')
    endif
    r = sqrt( r )
    s = sqrt( s )
    call orien1(xp, xq, angl)
    call matrot(angl, mro)
    call pmavec('ZERO', 3, mro, xpr, xxpr)
    if (xxpr(2) .eq. zero .and. xxpr(3) .eq. zero) then
        angl(3) = zero
    else
        angl(3) = atan2 ( xxpr(3) , xxpr(2) )
    endif
!
end subroutine
