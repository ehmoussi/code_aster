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

subroutine cjsc3q(sig, x, pa, qinit, q,&
                  qii, cos3tq, devnul, trac)
    implicit none
!     CALCUL DE COS(3*( ANGLE DE LODES POUR Q))
!     ------------------------------------------------------------------
!     IN
!          SIG      :  CONTRAINTES
!          X        :  VARIABLES ECROUI CINE
!          PA       :  PRESS ATMOSPHERIQUE ( DONNEE AMTERIAU)
!          QINIT    :   DONNEE AMTERIAU
!
!     OUT
!          Q        : DEV(SIG)-TRACE(SIG)*X
!          QII      : SQRT(QIJ*QIJ)
!          COS3TQ   : SQRT(54)*DET(Q)/(QII**3)
!          DEVNUL   : VRAI SI DEVIATEUR DE Q NUL
!          TRAC     : VRAI SI I1  NUL
!
!     ------------------------------------------------------------------
!
#include "asterf_types.h"
#include "asterfort/cjsqij.h"
#include "asterfort/lcdete.h"
#include "asterfort/lcdevi.h"
#include "asterfort/lcprsc.h"
    integer :: ndt, ndi
!
!
    common /tdim/   ndt, ndi
!
    real(kind=8) :: sig(6), x(6), pa, qinit, q(6), qii, cos3tq
    aster_logical :: devnul, trac
    real(kind=8) :: i1, s(6), qiirel
    real(kind=8) :: detq, pref
    integer :: i
    real(kind=8) :: zero, un, trois, epssig
!
    parameter     ( zero  = 0.d0   )
    parameter     ( un    = 1.d0   )
    parameter     ( trois = 3.d0   )
    parameter     ( epssig = 1.d-8   )
!
!
!
!
!
    i1 = zero
    do 10 i = 1, ndi
        i1 = i1 + sig(i)
 10 continue
!
!
    if ((i1+qinit) .eq. 0.d0) then
        i1 = -qinit+1.d-12 * pa
        pref = abs(pa)
    else
        pref = abs(i1+qinit)
    endif
!
!
!
    if ((i1+qinit) .gt. 0.d0) then
        trac = .true.
    else
        trac = .false.
    endif
!
!
    call lcdevi(sig, s)
    call cjsqij(s, i1, x, q)
    call lcprsc(q, q, qii)
    qii = sqrt(qii)
    qiirel = qii/pref
    call lcdete(q, detq)
    if (qiirel .gt. epssig) then
        devnul = .false.
        cos3tq = sqrt(54.d0)*detq/qii**trois
    else
        cos3tq = un
        devnul = .true.
    endif
!
    if (cos3tq .ge. 1.d0) cos3tq = 0.999999999999999d0
    if (cos3tq .le. -1.d0) cos3tq = -0.999999999999999d0
end subroutine
