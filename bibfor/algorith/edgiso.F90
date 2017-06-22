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

subroutine edgiso(dp, pm, eqsitr, mu, gamma,&
                  m, n, seuil, dseuil)
    implicit none
!
!
    real(kind=8) :: dp, pm, eqsitr
    real(kind=8) :: mu, gamma(3), m(3), n(3)
    real(kind=8) :: seuil, dseuil
!
!
! ----------------------------------------------------------------------
!     MODELE VISCOPLASTIQUE SANS SEUIL DE EDGAR
!    CALCUL DE LA FONCTION SEUIL ET DE SA DERIVEE
!    SEUIL(DP)=EQSITR-3*MU*DP-GAMMA(K)*((PM+DP)**M(K))*(DP**N(K))
!  IN  DP      : INCREMENT DE DEFORMATION PLASTIQUE CUMULEE
!  IN  PM      : DEFORMATION PLASTIQUE CUMULEE A L INSTANT MOINS
!  IN  EQSITR : CONTRAINTE EQUIVALENTE ESSAI
!  IN  MU      : COEFFICIENT DE MATERIAU ELASTIQUE
!  IN  GAMMA   : COEFFICIENT VISQUEUX A MULTIPLIER PAR 2*MU
!  IN  M       : COEFFICIENT VISQUEUX
!  IN  N       : COEFFICIENT VISQUEUX
!
!  OUT SEUIL   : FONCTION SEUIL
!  OUT DSEUIL  : DERIVEE DE SEUIL
! ----------------------------------------------------------------------
!
    integer :: k
!
! 1 - FONCTION F
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    seuil = eqsitr-3.d0*mu*dp
    do 10 k = 1, 3
        seuil=seuil-2.d0*mu*gamma(k)*((pm+dp)**m(k))*(dp**n(k))
10  end do
!
! 2 - DERIVEE DE LA FONCTION F
!
    dseuil = -3.d0*mu
    do 20 k = 1, 3
        dseuil=dseuil -2.d0*mu*gamma(k)*m(k)*((pm+dp)**(m(k)-1.d0))*(&
        dp**n(k)) -2.d0*mu*gamma(k)*n(k)*((pm+dp)**m(k))*(dp**(n(k)-&
        1.d0))
20  end do
!
end subroutine
