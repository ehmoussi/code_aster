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

subroutine chbfsx(sig, x1, x2, i4, ddfdsx)
    implicit none
!       DERIVEE / S / X DE LA NORMALE A LA FONCTION SEUIL A (SIG,X1,X2)
!       IN  SIG    :  TENSEUR CONTRAINTE
!       IN  X1     :  TENSEUR CINEMATIQUE 1
!       IN  X2     :  TENSEUR CINEMATIQUE 2
!                                                       T
!       OUT  DDFDSX:  DDFDSX = -1/S ( 3/2 I4 - DFDS DFDS )
!                     DFDS   = 3 (D-X1-X2) / 2 S
!                                           T           1/2
!                     S      = (3/2(D-X1-X2) (D-X1-X2))
!                     D      = SIG - 1/3 TR(SIG) I
!       ----------------------------------------------------------------
#include "asterfort/chbfs.h"
#include "asterfort/lcdevi.h"
#include "asterfort/lcdima.h"
#include "asterfort/lcdive.h"
#include "asterfort/lcnrts.h"
#include "asterfort/lcprsm.h"
#include "asterfort/lcprte.h"
    integer :: n, nd
    real(kind=8) :: dfds(6), sig(6), x1(6), x2(6), dev(6), s
    real(kind=8) :: ddfdsx(6, 6), dfds2(6, 6)
    real(kind=8) :: i4(6, 6)
    common /tdim/   n , nd
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    call lcdevi(sig, dev)
    call lcdive(dev, x1, dev)
    call lcdive(dev, x2, dev)
    s = lcnrts ( dev )
    call chbfs(sig, x1, x2, dfds)
    call lcprte(dfds, dfds, dfds2)
    call lcprsm(1.5d0, i4, ddfdsx)
    call lcdima(ddfdsx, dfds2, ddfdsx)
    call lcprsm(-1.d0 / s, ddfdsx, ddfdsx)
end subroutine
