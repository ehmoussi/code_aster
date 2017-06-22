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

function dmvdp1(rho11, rho12, sat, dsatp1, phi,&
                cs, pvp, emmag, em)
    implicit none
#include "asterf_types.h"
    real(kind=8) :: rho11, rho12, sat, dsatp1, phi, cs, pvp, dmvdp1
    real(kind=8) :: em, dphip1
    aster_logical :: emmag
! ======================================================================
!
! --- CALCUL DE L APPORT MASSIQUE DE VAPEUR PAR RAPPORT A LA PRESSION --
! --- CAPILLAIRE -------------------------------------------------------
! ======================================================================
    if (emmag) then
        dphip1 = - sat*em
        dmvdp1 = rho12 * (-dsatp1*phi + (1.d0-sat)*dphip1 - phi*(1.d0- sat)/pvp*rho12/rho11)
    else
        dmvdp1 = rho12 * (-dsatp1*phi - (1.d0-sat)*sat*cs - phi*(1.d0- sat)/pvp*rho12/rho11)
! ======================================================================
    endif
end function
