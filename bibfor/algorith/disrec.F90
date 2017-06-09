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

subroutine disrec(pz, az, bz, r, h)
!
! person_in_charge: samuel.geniaut at edf.fr
!
    implicit none
#include "asterfort/assert.h"
    real(kind=8) :: pz(2), az, bz, r, h, xc, yc
!
!
!      CALCUL DE H : DISTANCE SIGNEE ENTRE LE POINT P ET LE RECTANGLE
!      DE CENTRE (0,0), DE DEMI-GRAND AXE A ET DE DEMI-PETIT AXE B
!      DONT L'ANGLE DROIT PEUT ETRE ARRONDI AVEC LE RAYON D
!
! IN  PZ     : POINT DU PLAN DONT ON CHERCHE LA DISTANCE AU RECTANGLE
! IN  AZ     : DEMI-GRAND AXE DU RECTANGLE (SUIVANT L'AXE X)
! IN  BZ     : DEMI-PETIT AXE DU RECTANGLE (SUIVANT L'AXE Y)
! IN  R      : RAYON DE L'ANGLE
! OUT H      : DISTANCE SIGNEE ENTRE LE POINT P ET LE RECTANGLE
!
    real(kind=8) :: a, b, temp, p(2), x, y
!
!     ON ADOPTE LA MEME CONFIGURATION QUE CELLE DE LA ROUTINE DISELL :
!     LE QUART DU RECTANGLE CONSIDERE EST DANS LE PLAN OXY
!
!     CHOIX DU SIGNE DE LA DISTANCE H :
!     H EST NEGATIF A L'INTERIEUR DU RECTANGLE
!     H EST POSITIF A L'EXTERIEUR DU RECTANGLE
!
!     TRAVAIL SUR DES VARIABLES LOCALES CAR ON RISQUE DE LES MODIFIER
    a = az
    b = bz
    p(1) = pz(1)
    p(2) = pz(2)
!
!     VERIFICATIONS
    ASSERT(a.gt.0.d0 .and. b.gt.0.d0)
    if (a .lt. b) then
!       SI A EST PLUS PETIT QUE B, ON INVERSE A ET B
!       ET AUSSI LES COORDONNÉES DU POINT P
        temp = a
        a = b
        b = temp
        temp = p(1)
        p(1) = p(2)
        p(2) = temp
    endif
!
!     DEFINITION DE QUELQUES VARIABLES UTILES
!     ---------------------------------------
!
!     ABSCISSE ET ORDONNEE DU POINT P (TOUJOURS POSITIVES)
    x=abs(p(1))
    y=abs(p(2))
!
!     ABSCISSE ET ORDONNEE DU CENTRE DU CONGE
    xc = a-r
    yc = b-r
!
    ASSERT(a.ge.b)
    ASSERT(x.ge.0.d0)
    ASSERT(y.ge.0.d0)
!
!     CALCUL DE LA DISTANCE SIGNEE
!     ----------------------------
!
    if (y .ge. x+b-a .and. x .le. xc) then
!
!       ZONE 1
        h = y-b
!
    else if (y.le.x+b-a .and. y.le.yc) then
!
!       ZONE 2
        h = x-a
!
    else
!
!       ZONE 3
        h = sqrt( (x-xc)**2 + (y-yc)**2 ) - r
!
    endif
!
end subroutine
