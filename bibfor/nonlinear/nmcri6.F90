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

function nmcri6(dp)
    implicit none
!
!     ARGUMENTS:
!     ----------
#include "asterfort/ecpuis.h"
    real(kind=8) :: nmcri6, dp
! ----------------------------------------------------------------------
!   BUT: EVALUER LA FONCTION DONT ON CHERCHE LE ZERO POUR LA PLASTICITE
!        DE VON_MISES ISOTROPE AVEC ECROUISSAGE EN PUISSANCE SIMO_MIEHE
!
!    IN: DP     : DEFORMATION PLASTIQUE CUMULEE
!   OUT: NMCRI6 : CRITERE NON LINEAIRE A RESOUDRE EN DP
!                   (DONT ON CHERCHE LE ZERO)
!                   ICI ON SUPPOSE LE CRITERE DE VON_MISES
!                   AVEC ECROUISSAGE ISOTROPE EN PUISSANCE
!
! ----------------------------------------------------------------------
!     VARIABLES LOCALES:
!     ------------------
    real(kind=8) :: unsurn, rpp, rprim
!
!----- COMMONS NECESSAIRES A VON_MISES ISOTROPE PUISSANCE :
!      COMMONS COMMUNS A NMCRI2 ET NMISOT
!
    common /rconm6/mutrbe,tauteq
    real(kind=8) :: mutrbe, tauteq
!
    integer :: jprol, jvale, nbval
    real(kind=8) :: pm, young, nu, mu, unk, troisk, cother, sigy
    real(kind=8) :: sigm0, epsi0, dt, coefm, rpm, pente, apui, npui
    common /lcpim/&
     &          pm,young,nu,mu,unk,troisk,cother,&
     &          sigm0,epsi0,dt,coefm,rpm,pente,&
     &          apui,npui,sigy,jprol,jvale,nbval
!
! DEB-------------------------------------------------------------------
!
    unsurn=1.d0/npui
    call ecpuis(young, sigy, apui, unsurn, pm,&
                dp, rpp, rprim)
    nmcri6= rpp + mutrbe*dp - tauteq
!
end function
