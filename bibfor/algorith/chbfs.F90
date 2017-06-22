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

subroutine chbfs(sig, x1, x2, dfds)
    implicit none
!       3D / 1D / DP / CP
!       DERIVEE / SIG DE   LA FONCTION SEUIL A (SIG , X1 , X2 ) DONNES
!
!       IN  SIG    :  TENSEUR CONTRAINTE
!       IN  X1     :  TENSEUR CINEMATIQUE 1
!       IN  X2     :  TENSEUR CINEMATIQUE 2
!       OUT DFDS   :  NORMALE DFDS = 3 (D-X1-X2) / 2 S
!                                                T           1/2
!                             S    = (3/2(D-X1-X2) (D-X1-X2))
!                       ET    D    = SIG - 1/3 TR(SIG) I
!       ----------------------------------------------------------------
#include "asterfort/lcdevi.h"
#include "asterfort/lcdive.h"
#include "asterfort/lcnrts.h"
#include "asterfort/lcprsv.h"
    integer :: n, nd
    real(kind=8) :: dfds(6), sig(6), x1(6), x2(6), dev(6), s
    common /tdim/   n , nd
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    call lcdevi(sig, dev)
    call lcdive(dev, x1, dev)
    call lcdive(dev, x2, dev)
    s = lcnrts ( dev )
    call lcprsv(1.5d0 / s, dev, dfds)
end subroutine
