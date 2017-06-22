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

subroutine discrt(ff0, ff1, ff2, nbpt, amor,&
                  f)
    implicit none
! RENVOIT UNE DICRETISATION DE L'INTERVALLE F1,F2 EN NBPT POINT QUI
! ASSURE UNE BONNE DESCRPTION DE LA FONCTION H=1/(1-F**2+2I*F*AMOR)
!     -----------------------------------------------------------------
! IN  :F1,F2     R8  :BORNES DE L'INTERVALLE DISCRETISE
! IN  :AMOR      R8  :AMORTISSEMENT GENERALISE
! IN  :NBPT      INT :NOMBRE DE POINTS DESIRES
! OUT :F(*)      R8  :DICRETISATION
!     -----------------------------------------------------------------
#include "asterfort/fitof.h"
#include "asterfort/phase.h"
#include "asterfort/transf.h"
    integer :: nbpt, i1
    real(kind=8) :: ff0, ff1, ff2, f1, f2, f(*), amor, phi, phi1, phi2
    complex(kind=8) :: icmplx, horig, hbid
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    f1=ff1/ff0
    f2=ff2/ff0
    icmplx=dcmplx(0.d0,1.d0)
    if (amor .eq. 0.d0) then
        do 104,i1=1,nbpt
        f(i1)=ff1+(ff2-ff1)/(nbpt-1)*(i1-1)
104      continue
        goto 9999
    endif
    horig=1/2.d0/amor/icmplx/2.d0
    call transf(f1, amor, hbid)
    phi1=phase((hbid-horig)/icmplx)
    call transf(f2, amor, hbid)
    phi2=phase((hbid-horig)/icmplx)
    do 103,i1=1,nbpt
    phi=phi1+(phi2-phi1)/(nbpt-1)*(i1-1)
    f(i1)=fitof(phi,f1,f2,amor,horig)*ff0
    103 end do
9999  continue
end subroutine
