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

function norsig(sigma, nbsig)
    implicit none
    real(kind=8) :: norsig
    real(kind=8) :: sigma(nbsig)
!     BUT           : CALCUL DE LA NORME DU TENSEUR DE CONTRAINTES
!                     SIGMA AU SENS SUIVANT :
!                     NORSIG = SIGMA(I,J)*SIGMA(I,J)
! IN  SIGMA(NBSIG)  : VECTEUR DES COMPOSANTES DU TENSEUR DE CONTRAINTES
! IN  NBSIG         : NOMBRE DE CONTRAINTES POUR UN TYPE D'ELEMENT
!                     DONNE
!-----------------------------------------------------------------------
    real(kind=8) :: norsi2
!
!-----------------------------------------------------------------------
    integer :: i, nbsig
    real(kind=8) :: deux, zero
!-----------------------------------------------------------------------
    zero = 0.0d0
    deux = 2.0d0
    norsig = zero
    norsi2 = zero
!
    do 10 i = 1, 3
        norsi2 = norsi2 + sigma(i)*sigma(i)
10  end do
!
    do 20 i = 4, nbsig
        norsi2 = norsi2 + deux*sigma(i)*sigma(i)
20  end do
!
    norsig = sqrt(norsi2)
!
end function
