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

subroutine xdeffk(kappa, mu, r, theta, ndim, fkpo)
!
! person_in_charge: samuel.geniaut at edf.fr
!
    implicit none
#include "jeveux.h"
#include "asterc/r8depi.h"
!
    integer :: ndim
    real(kind=8) :: r, theta, fkpo(ndim,ndim), kappa, mu
!
!
!     BUT:  FONCTIONS D'ENRICHISSEMENT DANS LA BASE POLAIRE (R,THETA)
!
! IN  R      : PREMIERE COORDONNEE DANS LA BASE POLAIRE
! IN  THETA  : SECONDE COORDONNEE DANS LA BASE POLAIRE
! OUT FKPO     : VALEURS DES FONCTIONS D'ENRICHISSEMENT <VECTORIELLES>
!
!
    real(kind=8) :: rr
!---------------------------------------------------------------
!
    rr=sqrt(r)/(2.d0*mu*sqrt(r8depi()))
!
!     FONCTIONS D'ENRICHISSEMENT
    fkpo(1,1) = rr * ( kappa - cos(theta) ) * cos(theta/2.d0)
    fkpo(1,2) = rr * ( kappa - cos(theta) ) * sin(theta/2.d0)
    fkpo(2,1) = rr * ( kappa + 2.d0 + cos(theta) ) * sin(theta/2.d0)
    fkpo(2,2) = rr * ( 2.d0 - kappa - cos(theta) ) * cos(theta/2.d0)
    if (ndim.eq.3) then
      fkpo(1:2,3) = 0.d0
      fkpo(3,1:2) = 0.d0
      fkpo(3,3) = 4.d0*rr * sin(theta/2.d0)
    endif
!
end subroutine
