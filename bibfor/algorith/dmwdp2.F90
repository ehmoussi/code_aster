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

function dmwdp2(rho11, sat, phi, cs, cliq,&
                dp11p2, emmag, em)
    implicit none
#include "asterf_types.h"
    real(kind=8) :: rho11, sat, phi, cs, cliq, dp11p2, dmwdp2
    real(kind=8) :: em
    real(kind=8) :: dphip2
    aster_logical :: emmag
! ======================================================================
!
! --- CALCUL DE LA DERIVEE DE L APPORT MASSIQUE DE L EAU PAR RAPPORT ---
! --- A LA PRESSION DE GAZ ---------------------------------------------
! ======================================================================
    if (emmag) then
        dphip2 = em
        dmwdp2 = rho11 *(phi*dphip2+phi*cliq*dp11p2)
    else
        dmwdp2 = rho11*sat*(phi*cliq*dp11p2+cs)
    endif
! ======================================================================
end function
