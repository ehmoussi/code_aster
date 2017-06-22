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

subroutine mmmmpb(rese, nrese, ndim, matprb)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterfort/assert.h"
#include "asterfort/matini.h"
    real(kind=8) :: rese(3), nrese
    integer :: ndim
    real(kind=8) :: matprb(3, 3)
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE - UTILITAIRE)
!
! CALCUL DE LA MATRICE DE PROJECTION SUR LA BOULE UNITE
!
! ----------------------------------------------------------------------
!
!
! IN  RESE   : SEMI-MULTIPLICATEUR GTK DE FROTTEMENT (x)
!               GTK = LAMBDAF + COEFAF*VITESSE
! IN  NRESE  : NORME DU SEMI-MULTIPLICATEUR GTK DE FROTTEMENT
! IN  NDIM   : DIMENSION DU PROBLEME
! IN  VEC    : LE VECTEUR A MULTIPLIER
! OUT MATPRB : MATRICE DE PROJECTION SUR LA BOULE UNITE
!                 K(x) = (Id-x*xt/!!x!!**)1/!!x!!
!
! ----------------------------------------------------------------------
!
    real(kind=8) :: norme, theta
    integer :: i, j
!
! ----------------------------------------------------------------------
!
! --- INITIALISATIONS
!
    call matini(3, 3, 0.d0, matprb)
    theta = 1.d0
    if (nrese .eq. 0.d0) then
        ASSERT(.false.)
    endif
!
! --- CALCUL DE LA NORME DE LAMBDA +RHO[[U]]_TAU
!
    norme = nrese*nrese
!
! --- CALCUL DE LA MATRICE
!
    do 10 i = 1, ndim
        do 15 j = 1, ndim
            matprb(i,j) = -theta*rese(i)*rese(j)/norme
 15     continue
 10 end do
!
    do 20 j = 1, ndim
        matprb(j,j) = 1.d0+matprb(j,j)
 20 end do
!
    do 30 i = 1, ndim
        do 35 j = 1, ndim
            matprb(i,j) = matprb(i,j)/nrese
 35     continue
 30 end do
!
end subroutine
