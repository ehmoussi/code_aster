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

function dmwdp1(rho11, signe, sat, dsatp1, phi,&
                cs, cliq, dp11p1, emmag, em)
! ======================================================================
!
! --- CALCUL DE LA DERIVEE DE L APPORT MASSIQUE DE L EAU PAR RAPPORT ---
! --- A LA PRESSION CAPILLAIRE -----------------------------------------
! ======================================================================
    implicit none
#include "asterf_types.h"
    real(kind=8) :: rho11, signe, sat, dsatp1, phi, cs, cliq, dp11p1
    real(kind=8) :: dmwdp1, em
    real(kind=8) :: dphip1
    aster_logical :: emmag
!
    if (emmag) then
        dphip1 = - sat*signe*em
        dmwdp1 = rho11 *(sat*dphip1+signe*dsatp1*phi- signe *sat*phi* cliq*dp11p1)
    else
        dmwdp1 = rho11 * signe * (dsatp1*phi - sat*phi*cliq*dp11p1 - sat*sat*cs)
    endif
! ======================================================================
end function
