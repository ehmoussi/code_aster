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

subroutine lkd2de(devsig, d2dets)
! person_in_charge: alexandre.foucault at edf.fr
    implicit   none
!     ------------------------------------------------------------------
!     CALCUL DE DERIVEE 2NDE DE DET(S) PAR RAPPORT A DEVIATEUR SIGMA
!     IN  DEVSIG : DEVIATEUR DES CONTRAINTES
!
!     OUT D2DETS : DERIVEE 2NDE DET(S) PAR RAPPORT A SIGMA (NDT X NDT)
!     ------------------------------------------------------------------
#include "asterfort/lcinma.h"
    real(kind=8) :: devsig(6), d2dets(6, 6)
!
    integer :: ndi, ndt
    real(kind=8) :: zero, deux, r2
    parameter       ( zero   = 0.0d0 )
    parameter       ( deux   = 2.0d0 )
!     ------------------------------------------------------------------
    common /tdim/   ndt,ndi
!     ------------------------------------------------------------------
    call lcinma(zero, d2dets)
!
    r2 = sqrt(deux)
!
    if (ndt .eq. 6) then
        d2dets(1,2) = devsig(3)
        d2dets(1,3) = devsig(2)
        d2dets(1,6) = -devsig(6)
        d2dets(2,1) = devsig(3)
        d2dets(2,3) = devsig(1)
        d2dets(2,5) = -devsig(5)
        d2dets(3,1) = devsig(2)
        d2dets(3,2) = devsig(1)
        d2dets(3,4) = -devsig(4)
        d2dets(4,3) = -devsig(4)
        d2dets(4,4) = -devsig(3)
        d2dets(4,5) = devsig(6)/r2
        d2dets(4,6) = devsig(5)/r2
        d2dets(5,2) = -devsig(5)
        d2dets(5,4) = devsig(6)/r2
        d2dets(5,5) = -devsig(2)
        d2dets(5,6) = devsig(4)/r2
        d2dets(6,1) = -devsig(6)
        d2dets(6,4) = devsig(5)/r2
        d2dets(6,5) = devsig(4)/r2
        d2dets(6,6) = -devsig(1)
    else if (ndt.eq.4) then
        d2dets(1,2) = devsig(3)
        d2dets(2,1) = devsig(3)
        d2dets(1,3) = devsig(2)
        d2dets(3,1) = devsig(2)
        d2dets(2,3) = devsig(1)
        d2dets(3,2) = devsig(1)
        d2dets(4,4) = -devsig(3)
        d2dets(4,3) = -devsig(4)
        d2dets(3,4) = -devsig(4)
    endif
!
end subroutine
