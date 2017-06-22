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

subroutine edgini(itemax, prec, pm, eqsitr, mu,&
                  gamma, m, n, dp, iret)
    implicit none
!
!
#include "asterfort/edgiso.h"
    integer :: itemax
    real(kind=8) :: prec, pm, eqsitr
    real(kind=8) :: mu, gamma(3), m(3), n(3)
    real(kind=8) :: dp
    integer :: iret
!
!
! ----------------------------------------------------------------------
!     MODELE VISCOPLASTIQUE SANS SEUIL DE EDGAR
!    CALCUL DE LA SOLUTION CORRESPONDANT A LA MATRICE ANI ISOTROPE
!    ON SE RAMENE A UNE SEULE EQUATION EN DP
!    SEUIL(DP)=EQSITR-3*MU*DP-GAMMA(K)*((PM+DP)**M(K))*(DP**N(K))=0
!  IN  PM      : DEFORMATION PLASTIQUE CUMULEE A L INSTANT MOINS
!  IN  EQSITR : CONTRAINTE EQUIVALENTE ESSAI
!  IN  MU      : COEFFICIENT DE MATERIAU ELASTIQUE
!  IN  GAMMA   : COEFFICIENT VISQUEUX
!  IN  M       : COEFFICIENT VISQUEUX
!  IN  N       : COEFFICIENT VISQUEUX
!
!  OUT DP      : INCREMENT DE DEFORMATION PLASTIQUE CUMULEE
!  OUT IRET    : CODE RETOUR CALCUL
!                              IRET=0 => PAS DE PROBLEME
!                              IRET=1 => ECHEC
! ----------------------------------------------------------------------
!
    integer :: iter
    real(kind=8) :: dpinf, dpsup, seuil, dseuil
!                              IRET=1 => ECHEC
! ----------------------------------------------------------------------
!
! 1 - MINORANT ET MAJORANT
!
    dpinf = 0.d0
    dpsup = eqsitr/(3.d0*mu)
    iret = 0
!
! 2 - INITIALISATION
!     CALCUL DE SEUIL ET DE SA DERIVEE DSEUIL
!
    dp = dpsup
    call edgiso(dp, pm, eqsitr, mu, gamma,&
                m, n, seuil, dseuil)
!
! 3 - RESOLUTION PAR UNE METHODE DE NEWTON ENTRE LES BORNES
!
    do 10 iter = 1, itemax
        if (abs(seuil) .le. prec*eqsitr) goto 100
!
        dp = dp - seuil/dseuil
        if (dp .le. dpinf .or. dp .ge. dpsup) dp=(dpinf+dpsup)/16.d0
!
        call edgiso(dp, pm, eqsitr, mu, gamma,&
                    m, n, seuil, dseuil)
!
        if (seuil .ge. 0.d0) dpinf = dp
        if (seuil .le. 0.d0) dpsup = dp
!
10  end do
!
    iret = 1
!
100  continue
!
end subroutine
