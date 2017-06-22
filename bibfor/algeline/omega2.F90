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

function omega2(freq)
    implicit none
#include "asterc/r8depi.h"
    real(kind=8) :: omega2, freq
!     CALCULE LA PULSATION OMEGA**2 ASSOCIEE A LA FREQUENCE FREQ
!              OMEGA**2 = ( FREQ * 2*PI ) ** 2
!     ------------------------------------------------------------------
!     REMARQUE : SI LA FREQUENCE D'ENTREE EST NEGATIVE
!                   ALORS ON RETOURNE  (-OMEGA2)
!     ------------------------------------------------------------------
    real(kind=8) :: depide
    save                 depide
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    data                 depide/-1.d0/
!     ------------------------------------------------------------------
    if (depide .lt. 0) then
        depide = r8depi()
        depide = depide * depide
    endif
    if (freq .ge. 0) then
        omega2 = + freq * freq * depide
    else
        omega2 = - freq * freq * depide
    endif
end function
