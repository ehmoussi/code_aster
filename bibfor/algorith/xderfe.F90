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

subroutine xderfe(r, theta, dfedp)
!
! person_in_charge: samuel.geniaut at edf.fr
!
    implicit none
!
    real(kind=8) :: r, theta, dfedp(4, 2)
!
!
!     BUT : DERIVEES DES FONCTIONS D'ENRICHISSEMENT
!           DANS LA BASE POLAIRE (R,THETA)
!
! IN  R      : PREMIERE COORDONNEE DANS LA BASE POLAIRE
! IN  THETA  : SECONDE COORDONNEE DANS LA BASE POLAIRE
! OUT DFEDP  : DERIVEES DES FONCTIONS D'ENRICHISSEMENT
!
!----------------------------------------------------------------
!
    real(kind=8) :: rr, s, c, s2, c2
!
!----------------------------------------------------------------
!
!     DEFINITION DE QUELQUES VARIABLES UTILES
    rr = sqrt(r)
    s = sin(theta)
    c = cos(theta)
    s2 = sin(theta/2.d0)
    c2 = cos(theta/2.d0)
!
!     DÉRIVÉES DES FONCTIONS D'ENRICHISSEMENT DANS LA BASE POLAIRE
    dfedp(1,1) = 1.d0/(2.d0*rr) * s2
    dfedp(1,2) = rr/2.d0 * c2
    dfedp(2,1) = 1.d0/(2.d0*rr) * c2
    dfedp(2,2) = -rr/2.d0 * s2
    dfedp(3,1) = 1.d0/(2.d0*rr) * s2 * s
    dfedp(3,2) = rr * (c2*s/2.d0 + s2*c)
    dfedp(4,1) = 1.d0/(2.d0*rr) *c2 * s
    dfedp(4,2) = rr * (-s2*s/2.d0 + c2*c)
!
end subroutine
