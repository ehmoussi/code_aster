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

function nmcri1(dp)
    implicit none
!
!     ARGUMENTS:
!     ----------
#include "asterfort/rcfonc.h"
    real(kind=8) :: nmcri1, dp
! ----------------------------------------------------------------------
!    BUT:  EVALUER LA FONCTION DONT ON CHERCHE LE ZERO
!          POUR LA PLASTICITE DE VON_MISES ISOTROPE C_PLAN
!
!     IN:  DP     : DEFORMATION PLASTIQUE CUMULEE
!    OUT:  NMCRI1 : CRITERE NON LINEAIRE A RESOUDRE EN DP
!                   (DONT ON CHERCHE LE ZERO)
!                   ICI ON SUPPOSE LE CRITERE DE VON_MISES EN C_PLAN
!
! ----------------------------------------------------------------------
!     VARIABLES LOCALES:
!     ------------------
    real(kind=8) :: g, dx, rpp
!
!----- COMMONS NECESSAIRES A VON_MISES ISOTROPE C_PLAN :
!      COMMONS COMMUNS A NMCRI1 ET NMISOT
    common /rconm1/deuxmu,nu,e,sigy,rprim,pm,sigel,line
    common /rconm2/alfafa,unsurn,sieleq
    common /kconm1/imate2, jprol2, jvale2,nbval2
    real(kind=8) :: deuxmu, nu, e, sigy, rprim, pm, sigel(6), line
    integer :: imate2, jprol2, jvale2, nbval2
    real(kind=8) :: drdp, airerp, alfafa, unsurn, sieleq
!
! DEB-------------------------------------------------------------------
!
    if (line .ge. 0.5d0) then
        rpp = sigy +rprim*(pm+dp)
    else if (line.lt.-0.5d0) then
        rpp = sigy + sigy*(e*(pm+dp)/alfafa/sigy)**unsurn
    else
        call rcfonc('V', 1, jprol2, jvale2, nbval2,&
                    p = pm+dp, rp = rpp,&
                    rprim = drdp, airerp = airerp)
    endif
!
    dx = 3.d0*(1.d0-2.d0*nu)*sigel(3)*dp/(e*dp+2.d0*(1.d0-nu)*rpp)
!
    g = (&
        sigel(1)-deuxmu/3.d0*dx)**2 + (sigel(2)-deuxmu/3.d0*dx)**2 + (sigel(3)+deuxmu/3.d0*2.d0*d&
        &x)**2 + sigel(4&
        )**2
!
    nmcri1= 1.5d0*deuxmu*dp - sqrt(1.5d0*g) + rpp
!
end function
