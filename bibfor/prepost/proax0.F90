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

subroutine proax0(ui, vi, csta, cstb, a1,&
                  b1, u0, v0, rpax)
! person_in_charge: van-xuan.tran at edf.fr
    implicit      none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
    real(kind=8) :: ui, vi, csta, cstb, a1, b1, u0, v0, rpax
! ----------------------------------------------------------------------
! BUT: PROJETER SUR L'AXE 2 LES POINTS REPRESANTANT LE
!      CISAILLEMENT TAU DANS LE PLAN u, v.
! ----------------------------------------------------------------------
! ARGUMENTS:
! UI        IN   R  : COMPOSANTES u DU VECTEUR TAU (CISAILLEMENT),
!                     POUR LE VECTEUR NORMAL COURANT.
! VI        IN   R  : COMPOSANTES v DU VECTEUR TAU (CISAILLEMENT),
!                     POUR LE VECTEUR NORMAL COURANT.
! CSTA      IN   R  : CONSTANTE A POUR LE VECTEUR NORMAL COURANT.
! CSTB      IN   R  : CONSTANTE B POUR LE VECTEUR NORMAL COURANT.
! A1        IN   R  : CONSTANTE A1 POUR LE VECTEUR NORMAL COURANT.
! B1        IN   R  : CONSTANTE B1 POUR LE VECTEUR NORMAL COURANT.
! U0        IN   R  : VALEUR CENTRALE DES u, POUR LE VECTEUR NORMAL
!                     COURANT.
! V0        IN   R  : VALEUR CENTRALE DES v, POUR LE VECTEUR NORMAL
!                     COURANT.
! RPAX      OUT  R  : VALEUR DE L'AMPLITUDE DU POINT PROJETE SUR L'AXE
!                     CHOISI, POUR LE VECTEUR NORMAL COURANT.
!
!-----------------------------------------------------------------------
!     ------------------------------------------------------------------
    real(kind=8) :: uip, vip, a3, b3
    real(kind=8) :: up, vp, val
!-----------------------------------------------------------------------
!234567                                                              012
!
    call jemarq()
!
    rpax = 0.0d0
!
    uip = ui + 1.0d0
    vip = vi - (csta/cstb)*(uip-ui)
!
    a3 = (vip-vi)/(uip-ui)
    b3 = (uip*vi - ui*vip)/(uip-ui)
!
    up = (b3-b1)/(a1-a3)
    vp = (a1*b3 - a3*b1)/(a1-a3)
    val = sqrt((up-u0)**2 + (vp-v0)**2)
!
    if (up .lt. u0) then
        val = -val
    endif
    rpax = val
!
    call jedema()
end subroutine
