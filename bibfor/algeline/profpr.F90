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

subroutine profpr(icoq, rki, r1, r2, coepr1,&
                  coepr2, wpr)
    implicit none
! COUPLAGE FLUIDELASTIQUE, CONFIGURATIONS DU TYPE "COQUE_COAX"
! CALCUL DE COEFFICIENTS PONDERATEURS QUAND ON PREND EN COMPTE UN PROFIL
! RADIAL NON UNIFORME POUR LA PRESSION
! APPELANT : BIJSOM, PBFLUI
!-----------------------------------------------------------------------
!  IN : ICOQ   : INDICE CARACTERISANT LA COQUE EN MOUVEMENT POUR LE MODE
!                CONSIDERE (ICOQ=1 COQUE INTERNE  ICOQ=2 COQUE EXTERNE)
!  IN : RKI    : ORDRE DE COQUE DU MODE CONSIDERE
!  IN : R1     : RAYON REPERANT LA SURFACE DE LA STRUCTURE INTERNE
!  IN : R2     : RAYON REPERANT LA SURFACE DE LA STRUCTURE EXTERNE
! OUT : COEPR1 : COEFFICIENT PONDERATEUR POUR LA PRESSION EN R1
! OUT : COEPR2 : COEFFICIENT PONDERATEUR POUR LA PRESSION EN R2
! OUT : WPR    : VALEUR MOYENNE DU PROFIL DE PRESSION
!-----------------------------------------------------------------------
    integer :: icoq
    real(kind=8) :: rki, r1, r2, coepr1, coepr2, wpr
!-----------------------------------------------------------------------
!
! --- 1.INITIALISATIONS
!
!-----------------------------------------------------------------------
    integer :: ki
    real(kind=8) :: a, h0, r0, rc, t, x, y
    real(kind=8) :: z, z1, z2
!-----------------------------------------------------------------------
    r0 = (r1+r2)/2.d0
    h0 = r2 - r1
!
    rc = r2
    if (icoq .eq. 2) rc = r1
!
    ki = int(rki)
!
! --- 2.CALCUL DES COEFFICIENTS PONDERATEURS
!
    if (ki .eq. 1) then
        x = r0 + rc*rc*dble(log(r2/r1))/h0
        a = 1.d0/x
    else
        x = r2**(rki+1.d0) - r1**(rki+1.d0)
        x = x/(rki+1.d0)
        y = rc**(rki)
        y = y*y/(rki-1.d0)
        z1= r1**(rki-1.d0)
        z2= r2**(rki-1.d0)
        z = 1.d0/z1 - 1.d0/z2
        a = h0/(x+y*z)
    endif
!
    if (icoq .eq. 1) then
        t = (r2/r1)**(rki)
        coepr1 = a*(1.d0+t*t)*r1**(rki)
        coepr2 = 2.d0*a*r2**(rki)
    else
        t = (r1/r2)**(rki)
        coepr1 = 2.d0*a*r1**(rki)
        coepr2 = a*(1.d0+t*t)*r2**(rki)
    endif
!
! --- 3.CALCUL DE LA VALEUR MOYENNE
!
    if (ki .eq. 2) then
        x = (r1*r1+r2*r2)/2.d0
        y = rc*rc
        y = y*y*dble(log(r2/r1))/(r0*h0)
        wpr = a*(x+y)
    else
        x = r2**(rki+2.d0) - r1**(rki+2.d0)
        x = x/(rki+2.d0)
        y = rc**(rki)
        y = y*y/(rki-2.d0)
        z1= r1**(rki-2.d0)
        z2= r2**(rki-2.d0)
        z = 1.d0/z1 - 1.d0/z2
        wpr = a*(x+y*z)/(r0*h0)
    endif
!
end subroutine
