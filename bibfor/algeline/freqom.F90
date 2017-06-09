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

function freqom(omega)
    implicit none
#include "asterc/r8depi.h"
    real(kind=8) :: freqom, omega
!     CALCULE LA FREQUENCE FREQOM ASSOCIEE A LA PULSATION OMEGA
!              FREQUENCE = SQRT(OMEGA) / (2*PI)
!     ------------------------------------------------------------------
!     REMARQUE : SI LA PULSATION D'ENTREE EST NEGATIVE
!                   ALORS ON RETOURNE  (-FREQOM)
!     ------------------------------------------------------------------
    real(kind=8) :: depide
    save                 depide
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    data                 depide/-1.d0/
    if (depide .lt. 0) then
        depide = r8depi()
        depide = depide * depide
        depide = 1.d0 / depide
    endif
    if (omega .ge. 0.d0) then
        freqom = + sqrt( + omega * depide )
    else
        freqom = - sqrt( - omega * depide )
    endif
end function
