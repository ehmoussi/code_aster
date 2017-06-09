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

subroutine gdsmhy(je, e)
!
    implicit none
#include "asterc/r8maem.h"
#include "asterfort/lcdete.h"
#include "asterfort/lcdevi.h"
#include "asterfort/zerop3.h"
#include "blas/ddot.h"
    real(kind=8) :: je, e(6)
!
! ----------------------------------------------------------------------
!            GRANDES DEFORMATIONS SIMO-MIEHE OU CANO-LORENTZ
!         CORRECTION HYDROSTATIQUE DE LA DEFORMATION ELASTIQUE
! ----------------------------------------------------------------------
! IN  JE      DETERMINANT DE E CIBLE
! VAR E       DEFORMATION ELASTIQUE (XX,YY,ZZ,RAC2*XY,RAC2*XZ,RAC2*YZ)
! ----------------------------------------------------------------------
    integer :: nrac, i, iopt
    real(kind=8) :: dve(6), eh, eqe2, detdve, p0, p1, p2, rac(3), dismin
! ----------------------------------------------------------------------
!
!
!
    call lcdevi(e, dve)
    eqe2 = 1.5d0 * ddot(6,dve,1,dve,1)
    call lcdete(dve, detdve)
    eh = (e(1)+e(2)+e(3))/3.d0
!
    p0 = 8*detdve + je**2
    p1 = - 4.d0/3.d0*eqe2
    p2 = 0
    call zerop3(p2, p1, p0, rac, nrac)
    do 10 i = 1, nrac
        rac(i) = (rac(i)+1)/2
10  end do
!
    dismin = r8maem()
    do 20 i = 1, nrac
        if (abs(rac(i)-eh) .lt. dismin) then
            iopt = i
            dismin = abs(rac(i)-eh)
        endif
20  end do
    eh = rac(iopt)
!
    do 30 i = 1, 3
        e(i) = eh + dve(i)
30  end do
!
end subroutine
