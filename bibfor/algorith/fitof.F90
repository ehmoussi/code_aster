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

function fitof(phi, f1, f2, amor, horig)
    implicit none
! CETTE FONCTION RENVOIT LA FREQUENCE F TELLE QUE
!     PHASE(H-HORIG)=PHI OU H=1/(1-F**2+2I*F*AMOR)
!
! IN  :PHI      R8  :PHASE
! IN  :F1,F2    R8  :BORNES DU DOMAINE DANS LEQUEL ON RECHERCHE
! IN  :AMOR     R8  :AMORTISSEMENT REDUIT
! IN  :HORIG    C16 :DECALAGE DE L'ORIGINE POUR LES ANGLES
!     ------------------------------------------------------------------
#include "asterfort/phase.h"
#include "asterfort/transf.h"
    real(kind=8) :: phi, f1, f2, f3, eps, phi1, phi2, phi3, df, fitof, amor, fx1
    real(kind=8) :: fx2
    complex(kind=8) :: h1, h2, h3, horig
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    eps=0.000001d0
    fx1=f1
    fx2=f2
    call transf(fx1, amor, h1)
    call transf(fx2, amor, h2)
    phi1=phase((h1-horig)/dcmplx(0.d0,1.d0))
    phi2=phase((h2-horig)/dcmplx(0.d0,1.d0))
    if (((phi1-phi)*(phi2-phi)) .gt. 0.d0) then
    endif
101  continue
    f3=(fx1+fx2)/2.d0
    call transf(f3, amor, h3)
    phi3=phase((h3-horig)/dcmplx(0.d0,1.d0))
    df=abs(f3-fx1)
    if (df .lt. eps) then
        fitof=f3
        goto 9999
    endif
    if (phi3 .ge. phi) then
        fx1=f3
    else
        fx2=f3
    endif
    goto 101
9999  continue
end function
