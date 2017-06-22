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

function dmadp1(rho22, sat, dsatp1, phi, cs,&
                mamolg, kh, dp21p1, emmag, em)
    implicit none
#include "asterf_types.h"
    real(kind=8) :: rho22, sat, dsatp1, phi, cs, mamolg, kh, dp21p1, dmadp1
    real(kind=8) :: dphip1, em
    aster_logical :: emmag
! ======================================================================
!
! --- CALCUL DE LA DERIVEE DE L APPORT MASSIQUE DE L AIR DISSOUS PAR ---
! --- RAPPORT A LA PRESSION CAPILLAIRE ---------------------------------
! ======================================================================
    if (emmag) then
        dphip1 = - sat*em
        dmadp1 = rho22 * (dsatp1*phi + sat*phi*mamolg*dp21p1/rho22/kh + sat*dphip1)
    else
        dmadp1 = rho22 * (dsatp1*phi + sat*phi*mamolg*dp21p1/rho22/kh - sat*sat*cs)
    endif
! ======================================================================
end function
