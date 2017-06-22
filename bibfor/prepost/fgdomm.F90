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

subroutine fgdomm(nbcycl, dom, rdomm)
    implicit none
#include "jeveux.h"
    real(kind=8) :: dom(*), rdomm
    integer :: nbcycl
!     CUMUL DU DOMMAGE
!     ------------------------------------------------------------------
! IN  NBCYCL : I   : NOMBRE DE CYCLES
! IN  DOM    : R   : VALEURS DES DOMMAGES ELEMENTAIRES
! OUT RDOMM  : R   : VALEUR DU DOMMAGE TOTAL
!     ------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: i
!-----------------------------------------------------------------------
    rdomm = 0.d0
    do 10 i = 1, nbcycl
        rdomm = rdomm + dom(i)
10  end do
!
end subroutine
