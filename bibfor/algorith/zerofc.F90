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

subroutine zerofc(func, xmin, xmax, prec, niter,&
                  dp, iret, nit)
    implicit none
! aslint: disable=W0307
#include "asterfort/zeroco.h"
    interface
        function func(x)
            real(kind=8) :: x
            real(kind=8) :: func
        end function
    end interface
    integer :: niter, iret
    real(kind=8) :: xmin, xmax, prec, dp
! ----------------------------------------------------------------------
!     RECHERCHE DU ZERO DE func. ON SAIT QUE VAL0=func(0) < 0 ET func CROISSANTE
!     APPEL A ZEROCO (METHODE DE CORDE)
!
! IN  func       : FONCTION func
! IN  XMIN    : VALEUR DE X POUR LAQUELLE func(X) < 0 (XMIN = 0 EN GENERAL)
! IN  XMAX    : ESTIMATION DE LA VALEUR DE X POUR LAQUELLE func > 0
! IN  PREC    : PRECISION ABSOLUE : LA SOLUTION EST TELLE QUE func(DP)<PREC
! IN  NITER   : NOMBRE D'ITERATIONS MAXIMUM
! OUT DP      : SOLUTION : ACCROISSEMENT DE LA VARIABLE INTERNE P
! OUT IRET    : CODE RETOUR : IRET = 0 : OK
!             :               SINON : PB
! OUT NIT     : NOMBRE D'ITERATIONS NECESSAIRE POUR CONVERGER
!
    real(kind=8) :: x(4), y(4)
    integer :: i, nit
! DEB ------------------------------------------------------------------
!
    nit = 0
    iret = 1
    x(1) = xmin
    y(1) = func(xmin)
    x(2) = xmax
    y(2) = func(xmax)
    x(3) = x(1)
    y(3) = y(1)
    x(4) = x(2)
    y(4) = y(2)
!
    do 20 i = 1, niter
!
!       SOLUTION TROUVEE : ON SORT
        if (abs(y(4)) .lt. prec) then
            iret = 0
            nit=i
            goto 9999
        endif
!
        call zeroco(x, y)
!
        dp = x(4)
        y(4) = func(dp)
!
20  end do
!
9999  continue
end subroutine
