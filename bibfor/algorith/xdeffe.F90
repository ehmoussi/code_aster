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

subroutine xdeffe(r, theta, fe)
!
! person_in_charge: samuel.geniaut at edf.fr
!
    implicit none
!#include "asterfort/assert.h"
!
    real(kind=8) :: r, theta, fe(4)
!
!
!     BUT:  FONCTIONS D'ENRICHISSEMENT DANS LA BASE POLAIRE (R,THETA)
!
! IN  R      : PREMIERE COORDONNEE DANS LA BASE POLAIRE
! IN  THETA  : SECONDE COORDONNEE DANS LA BASE POLAIRE
! OUT FE      : VALEURS DES FONCTIONS D'ENRICHISSEMENT
!
!----------------------------------------------------------------
!
!     FONCTIONS D'ENRICHISSEMENT
!    ASSERT(.false.)
    fe(1) = sqrt(r) * sin(theta/2.d0)
    fe(2) = sqrt(r) * cos(theta/2.d0)
    fe(3) = sqrt(r) * sin(theta/2.d0) * sin(theta)
    fe(4) = sqrt(r) * cos(theta/2.d0) * sin(theta)
!
end subroutine
