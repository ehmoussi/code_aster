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

function biline(nordre, vect1, amat, vect2)
    implicit none
    real(kind=8) :: vect1(*), amat(*), vect2(*)
! ---------------------------------------------
!     BUT:   POUR LES ELEMENTS DE CABLE, CALCUL DE LA FORME BILINEAIRE:
!                         VECT1T * AMAT * VECT2
!            AMAT ETANT D'ORDRE NORDRE ET RANGEE PAR LIGNES DANS LE VEC-
!            TEUR AMAT: 1ERE LIGNE, PUIS 2EME LIGNE...
!     IN: NORDRE
!         VECT1
!         AMAT
!         VECT2
!     OUT: BILINE
! ---------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: i, j, k, nordre
    real(kind=8) :: biline, produi, zero
!-----------------------------------------------------------------------
    zero = 0.d0
    biline = zero
    k = 0
    do 2 i = 1, nordre
        produi = zero
        do 1 j = 1, nordre
            k = k + 1
            produi = produi + amat(k)*vect2(j)
 1      continue
        biline = biline + vect1(i)*produi
 2  end do
end function
