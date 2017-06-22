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

subroutine xderfk(kappa, mu, r, theta, ndim, dfkdpo)
!
! person_in_charge: samuel.geniaut at edf.fr
!
    implicit none
!
#include "asterc/r8depi.h"
!
    integer :: ndim
    real(kind=8) :: r, theta, dfkdpo(ndim,ndim,2), kappa, mu
!
!
!     BUT : DERIVEES DES FONCTIONS D'ENRICHISSEMENT
!           DANS LA BASE POLAIRE (R,THETA)
!
! IN  R      : PREMIERE COORDONNEE DANS LA BASE POLAIRE
! IN  THETA  : SECONDE COORDONNEE DANS LA BASE POLAIRE
! OUT DFKDPO : DERIVEES DES FONCTIONS D'ENRICHISSEMENT
!   -- FORMAT DE STOCKAGE DES DERIVEES --
!       DFKDPO(i, j, l)
!            i <-> Ki
!            j <-> Kij=Ki.ej
!            l <-> [dKij/dr dKij/dtheta]
!----------------------------------------------------------------
!
    real(kind=8) :: rr, drr, s, c, s2, c2
!
!----------------------------------------------------------------
!
    rr=sqrt(r)/(2.d0*mu*sqrt(r8depi()))
    drr=1.d0/(4.d0*mu*sqrt(r)*sqrt(r8depi()))
    s = sin(theta)
    c = cos(theta)
    s2 = sin(theta/2.d0)
    c2 = cos(theta/2.d0)
!
!     DÉRIVÉES DES FONCTIONS D'ENRICHISSEMENT DANS LA BASE POLAIRE
    dfkdpo(1,1:2,1) = drr * [ (kappa-c)*c2 , (kappa-c)*s2 ]
    dfkdpo(1,1:2,2) = rr * [ s*c2-0.5d0*(kappa-c)*s2 , s*s2+0.5d0*(kappa-c)*c2 ]
!
    dfkdpo(2,1:2,1) = drr * [ (kappa+2+c)*s2 , (2-kappa-c)*c2 ]
    dfkdpo(2,1:2,2) = rr * [ -s*s2+0.5d0*(kappa+2+c)*c2 , s*c2-0.5d0*(2-kappa-c)*s2]
!
    if (ndim.eq.3) then
      dfkdpo(1:2,3,1:2) = 0.d0
      dfkdpo(3,1:2,1:2) = 0.d0
      dfkdpo(3,3,1:2) = 4.d0*[drr*s2 , 0.5d0*rr*c2 ]
    endif
!
end subroutine
