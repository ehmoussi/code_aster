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

subroutine lcvpbo(a, b, l0, l1, etamin,&
                  etamax, vide, nsol, sol, sgn)
    implicit none
#include "asterf_types.h"
#include "asterc/r8gaem.h"
    aster_logical,intent(out) :: vide
    integer, intent(out) :: nsol, sgn(2)
    real(kind=8), intent(in) :: a, b, l0, l1, etamin, etamax
    real(kind=8), intent(out) :: sol(2)
!
! ----------------------------------------------------------------------
!  SOLUTION Q(ETA) := (A*ETA+B)**2 + L0 + ETA*L1 = 0
! ----------------------------------------------------------------------
!  IN  A,B    COMPOSANTES DU TERME QUADRATIQUE
!  IN  L0,L1  COMPOSANTES DU TERME AFFINE
!  IN  ETAMIN BORNE MIN
!  IN  ETAMAX BORNE MAX
!  OUT VIDE   .TRUE. SI Q TJRS POSITIF DANS L'INTERVALLE
!  OUT NSOL   NOMBRE DE SOLUTIONS (0, 1 OU 2)
!  OUT SOL    VALEURS DES SOLUTIONS
!  OUT SGN    SIGNE DE DQ/DETA EN CHAQUE SOLUTION
! ----------------------------------------------------------------------
    real(kind=8) :: small, qmin, qmax, m0, m1, lmin, lmax
    real(kind=8) :: dqmin, dqmax, qopt, mr0, mr1, rac
! ----------------------------------------------------------------------
!
!
!  INITIALISATION
    small = sqrt(1.d0/r8gaem())
    qmin = (a*etamin+b)**2 + l0 + etamin*l1
    qmax = (a*etamax+b)**2 + l0 + etamax*l1
!
!
!  FONCTION NEGATIVE PARTOUT
    if (qmin .le. 0 .and. qmax .le. 0) then
        vide = .false.
        nsol = 0
        goto 999
    endif
!
!
    m0 = l0 + b**2
    m1 = l1 + 2*a*b
    lmin = m0 + m1*etamin
    lmax = m0 + m1*etamax
!
!  TERME LINEAIRE POSITIF PARTOUT (DONC Q EGALEMENT)
    if (lmin .ge. 0 .and. lmax .ge. 0) then
        vide = .true.
        nsol = 0
        goto 999
    endif
!
!
!  CAS DES VALEURS POSITIVES AUX BORDS
    if (qmin .ge. 0 .and. qmax .ge. 0) then
!
!      SI LA FONCTION EST MONOTONE: LA FONCTION EST POSITIVE PARTOUT
        dqmin = 2*a**2*etamin+m1
        dqmax = 2*a**2*etamax+m1
        if (dqmin*dqmax .ge. 0) then
            vide = .true.
            nsol = 0
            goto 999
        endif
!
!      SINON LE MINIMUM EST ATTEINT DANS L'INTERVALLE
        qopt = m0 - (m1/(2*a))**2
!
!      SI LE MINIMUM EST POSITIF: LA FONCTION EST POSITIVE PARTOUT
        if (qopt .ge. 0) then
            vide = .true.
            nsol = 0
            goto 999
        endif
!
!      SINON, EXISTENCE DE DEUX SOLUTIONS
        mr0 = m0/a**2
        mr1 = m1/(2*a**2)
        rac = sqrt(abs(mr1**2-mr0))
        vide = .false.
        nsol = 2
        sol(1) = -mr1-rac
        sol(2) = -mr1+rac
        sgn(1) = -1
        sgn(2) = +1
        goto 999
    endif
!
!
!  CAS DES VALEURS DE Q OPPOSEES AUX BORDS
!
!  FONCTION QUASI-LINEAIRE
    if (a**2 .le. small*abs(m1)) then
        vide = .false.
        nsol = 1
        sol(1) = -m0/m1
        if (qmin .le. 0) then
            sgn(1) = 1
        else
            sgn(1) = -1
        endif
        goto 999
    endif
!
!  SINON: RESOLUTION PAR LE POLYNOME P2
    mr0 = m0/a**2
    mr1 = m1/(2*a**2)
    rac = sqrt(abs(mr1**2-mr0))
!
    vide = .false.
    nsol = 1
    if (qmin .le. 0) then
        sol(1) = -mr1+rac
        sgn(1) = 1
    else
        sol(1) = -mr1-rac
        sgn(1) = -1
    endif
!
!
999 continue
end subroutine
