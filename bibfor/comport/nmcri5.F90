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

function nmcri5(dp)
    implicit none
!
!     ARGUMENTS:
!     ----------
#include "asterfort/rcfon2.h"
    real(kind=8) :: nmcri5, dp
! ----------------------------------------------------------------------
!    BUT:  EVALUER LA FONCTION DONT ON CHERCHE LE ZERO
!          POUR LA PLASTICITE DE VON_MISES ISOTROPE + CINEMATIQUE C_PLAN
!
!     IN:  DP     : DEFORMATION PLASTIQUE CUMULEE
!    OUT:  NMCRI5 : CRITERE NON LINEAIRE A RESOUDRE EN DP
!                   (DONT ON CHERCHE LE ZERO)
!                   ICI ON SUPPOSE LE CRITERE DE VON_MISES EN C_PLAN
!
! ----------------------------------------------------------------------
!
!----- COMMONS NECESSAIRES A VON_MISES ISOTROPE + CINEMATIQUE C_PLAN :
!      COMMONS COMMUNS A NMCRI1 ET NMECMI
    common /rconm5/deuxmu,troisk,sigy,rprim,pm,sigel,tp2,line,prag,xm
    common /kconm1/imate2, jprol2, jvale2,nbval2
!     VARIABLES LOCALES:
!     ------------------
    integer :: imate2, jprol2, jvale2, nbval2
    real(kind=8) :: drdp, prag, hp, fp, gp, hsg, dx, rpp, demuc, xm(6)
    real(kind=8) :: deuxmu, troisk, sigy, rprim, pm, sigel(6), tp2, line
!
! DEB-------------------------------------------------------------------
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    if (line .ge. 0.5d0) then
        rpp = sigy +rprim*(pm+dp)
    else
        call rcfon2('V', jprol2, jvale2, nbval2, &
                    p = pm+dp, rp = rpp, rprim = drdp,&
                    c = prag)
    endif
    gp=1.d0+1.5d0*prag*dp/rpp
    hp=gp+1.5d0*deuxmu*dp/rpp
    hsg=hp/gp
    demuc=deuxmu+prag
!
    dx=  (hsg-1.d0)* sigel(3)
    dx=dx/( deuxmu/1.5d0 + troisk*hsg/3.d0 )
!
    fp= (sigel(1)-deuxmu/3.d0*dx)**2 + (sigel(2)-deuxmu/3.d0*dx)**2 +&
     &    (sigel(3)+deuxmu/3.d0*2.d0*dx)**2 + sigel(4)**2
!
    nmcri5= 1.5d0*demuc*dp - sqrt(1.5d0*fp) + rpp
!
end function
