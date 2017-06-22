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

subroutine teneps(jrwork, adr, sig, eps, epse,&
                  epsp)
!
    implicit     none
#include "jeveux.h"
!
    integer :: jrwork, adr
    real(kind=8) :: sig(6), eps(6), epse(6), epsp(6)
!
!
! ---------------------------------------------------------------------
! BUT: POUR UN NUMERO D'ORDE, RECUPERER LES TENSEURS DE CONTRAINTE ET
!                      DEFORMATION
! ---------------------------------------------------------------------
! ARGUMENTS:
!    JRWORK : IN : ADRESSE DE VECTEUR DE TRAVAIL ACTUEL
!    ARD    : IN : DECALGE DU NUMRO D'ORDE EN COURS
!    SIG    : OUT : CONTRAINTE (6 COMPOSANTES)
!    EPS    : OUT : DEFORMATION TOTALE (6 COMPOSANTES)
!    EPSE   : OUT : DEFORMATION ELASTIQUE (6 COMPOSANTES)
!    SIG    : OUT : DEFORMATION PLASTIQUE (6 COMPOSANTES)
!-----------------------------------------------------------------------
    integer :: k
!
    do 25 k = 1, 6
        sig(k) = 0.0d0
        eps(k) = 0.0d0
        epse(k)= 0.0d0
        epsp(k)= 0.0d0
25  end do
!
    do 35 k = 1, 6
        sig(k) = zr(jrwork + adr + k - 1)
        eps(k) = zr(jrwork + adr + k - 1 + 6)
        epsp(k) = zr(jrwork + adr + k - 1 + 12)
        epse(k) = eps(k) - epsp(k)
35  end do
!
! ON SUPPOSE QUE EPS_TOT = EPS_ELAS + EPSPLAS
!
!       EPSE(1) = C1*SIG(1) - C2*(SIG(1) + SIG(2) + SIG(3))
!       EPSE(2) = C1*SIG(2) - C2*(SIG(1) + SIG(2) + SIG(3))
!       EPSE(3) = C1*SIG(3) - C2*(SIG(1) + SIG(2) + SIG(3))
!       EPSE(4) = C1*SIG(4)
!       EPSE(5) = C1*SIG(5)
!       EPSE(6) = C1*SIG(6)
!
!       DO 45 K = 1, 6
!         EPSP(K) =  EPS(K) - EPSE(K)
! 45    CONTINUE
!
end subroutine
