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

function dmasp1(rho11, rho12, rho21, sat, dsatp1,&
                phi, cs, pas, emmag, em)
    implicit none
#include "asterf_types.h"
    real(kind=8) :: rho11, rho12, rho21, sat, dsatp1, phi, cs, pas, dmasp1
    real(kind=8) :: em, dphip1
    aster_logical :: emmag
! ======================================================================
!
! --- CALCUL DE LA DERIVEE DE L APPORT MASSIQUE DE L AIR SEC PAR -------
! --- RAPPORT A LA PRESSION CAPILLAIRE ---------------------------------
! ======================================================================
    if (emmag) then
        dphip1 = - sat*em
        dmasp1 = rho21 * (-dsatp1*phi + (1.d0-sat)*dphip1 + phi*(1.d0- sat)/pas*rho12/rho11)
    else
        dmasp1 = rho21 * (-dsatp1*phi - (1.d0-sat)*sat*cs + phi*(1.d0- sat)/pas*rho12/rho11)
    endif
! ======================================================================
end function
