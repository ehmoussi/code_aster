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

subroutine rvegal(epsi, criter, x, y, ok,&
                  eccart)
    implicit none
#include "asterf_types.h"
!
!
    character(len=1) :: criter
    aster_logical :: ok
    real(kind=8) :: epsi, x, y, eccart
!
!********************************************************************
!
!     OPERATION REALISEE
!     ------------------
!
!       TEST DE L' EGALITE " X = Y "
!
!********************************************************************
!
    real(kind=8) :: seuil, z
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    eccart = x - y
    seuil = epsi
    z = abs(x)
!
    if ((criter .eq. 'R') .and. (z .ge. epsi)) then
!
        seuil = seuil*z
!
    endif
!
    ok = ( abs(eccart) .lt. seuil)
!
end subroutine
