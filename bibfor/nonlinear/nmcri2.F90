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

function nmcri2(dp)
    implicit none
!
!     ARGUMENTS:
!     ----------
#include "asterfort/ecpuis.h"
    real(kind=8) :: nmcri2, dp
! ----------------------------------------------------------------------
!   BUT: EVALUER LA FONCTION DONT ON CHERCHE LE ZERO POUR LA PLASTICITE
!         DE VON_MISES ISOTROPE AVEC ECROUISSAGE EN PUISSANCE
!
!    IN: DP     : DEFORMATION PLASTIQUE CUMULEE
!   OUT: NMCRI2 : CRITERE NON LINEAIRE A RESOUDRE EN DP
!                   (DONT ON CHERCHE LE ZERO)
!                   ICI ON SUPPOSE LE CRITERE DE VON_MISES
!                   AVEC ECROUISSAGE ISOTROPE EN PUISSANCE
!
! ----------------------------------------------------------------------
!     VARIABLES LOCALES:
!     ------------------
    real(kind=8) :: rpp
!
!----- COMMONS NECESSAIRES A VON_MISES ISOTROPE PUISSANCE :
!      COMMONS COMMUNS A NMCRI2 ET NMISOT
    common /rconm1/deuxmu,nu,e,sigy,rprim,pm,sigel,line
    real(kind=8) :: deuxmu, nu, e, sigy, rprim, pm, sigel(6), line
    common /rconm2/alfafa,unsurn,sieleq
    real(kind=8) :: alfafa, unsurn, sieleq
!
! DEB-------------------------------------------------------------------
!
    call ecpuis(e, sigy, alfafa, unsurn, pm,&
                dp, rpp, rprim)
    nmcri2= rpp + 1.5d0*deuxmu*dp - sieleq
!
end function
