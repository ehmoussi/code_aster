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

function nmcri9(dp)
! person_in_charge: sebastien.fayolle at edf.fr
    implicit none
!
!     ARGUMENTS:
!     ----------
#include "asterfort/eccook.h"
    real(kind=8) :: nmcri9, dp
! ----------------------------------------------------------------------
!   BUT: EVALUER LA FONCTION DONT ON CHERCHE LE ZERO POUR LA PLASTICITE
!         DE VON_MISES ISOTROPE AVEC ECROUISSAGE DE JOHNSON_COOK
!
!    IN: DP     : DEFORMATION PLASTIQUE CUMULEE
!   OUT: NMCRI9 : CRITERE NON LINEAIRE A RESOUDRE EN DP
!                   (DONT ON CHERCHE LE ZERO)
!                   ICI ON SUPPOSE LE CRITERE DE VON_MISES
!                   AVEC ECROUISSAGE ISOTROPE EN PUISSANCE
!
! ----------------------------------------------------------------------
!     VARIABLES LOCALES:
!     ------------------
    real(kind=8) :: rpp
!
    common /rconm9/acook,bcook,ccook,npuis,mpuis,&
     &               epsp0,troom,tmelt,tp,dinst,sieleq,deuxmu,rprim,pm
!
    real(kind=8) :: acook, bcook, ccook, npuis, mpuis, epsp0, troom, tmelt
    real(kind=8) :: dinst
    real(kind=8) :: tp, sieleq, deuxmu, rprim, pm
!
! DEB-------------------------------------------------------------------
!
    call eccook(acook, bcook, ccook, npuis, mpuis,&
                epsp0, troom, tmelt, tp, dinst,&
                pm, dp, rpp, rprim)
    nmcri9= rpp + 1.5d0*deuxmu*dp - sieleq
!
end function
