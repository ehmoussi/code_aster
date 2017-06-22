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

subroutine frqapp(dt, neq, dep1, dep2, acc1,&
                  acc2, vmin, freq)
!
    implicit none
#include "asterc/r8depi.h"
#include "asterc/r8miem.h"
#include "asterc/r8prem.h"
    integer :: i
    real(kind=8) :: dep1(*), dep2(*), acc1(*), acc2(*), vmin(*)
    real(kind=8) :: freq, dt, a, b, temp
! CALCUL DE LA FREQUENCE APPARENTE POUR LE CALCUL AVEC PAS ADAPTATIF
! ----------------------------------------------------------------------
! IN  : DT     : PAS DE TEMPS
! IN  : NEQ    : NOMBRE D'EQUATIONS
! IN  : DEP1   : DEPLACEMENTS AU TEMPS T
! IN  : DEP2   : DEPLACEMENTS AU TEMPS T+DT
! IN  : ACC1   : ACCELERATIONS AU TEMPS T
! IN  : ACC2   : ACCELERATIONS AU TEMPS T+DT
! IN  : VMIN   : VITESSES DE REFERENCE
! OUT : FREQ   : FREQUENCE APPARENTE
! ------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: neq
    real(kind=8) :: dd, dmin, eps, epsmi
    real(kind=8) :: tt
!-----------------------------------------------------------------------
    temp = r8prem()
    eps = r8prem()
    epsmi = r8miem()
    do 10 i = 1, neq
        a = acc2(i)-acc1(i)
        dmin = vmin(i)*dt
        dd = abs(dep2(i)-dep1(i))
        if (dmin .ge. dd) then
            b = dmin
        else
            b = dd
        endif
!       B = MAX(VMIN(I)*DT,ABS(DEP2(I)-DEP1(I)))
!       B DEVRAIT ETRE TOUJOURS NON NUL
        if (b .le. epsmi) b=eps
        tt = abs(a/b)
        if (temp .le. tt) temp = tt
!       TEMP = MAX(TEMP,ABS(A/B))
10  end do
    freq = sqrt(temp)/r8depi()
end subroutine
