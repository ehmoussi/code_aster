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

subroutine pgyty(nno, npg, dfde, yty)
    implicit none
    real(kind=8) :: dfde(*), yty(*)
    real(kind=8) :: enprim(3, 2)
! ----------------------------------------------------------------------
!     BUT:   POUR LES ELEMENTS DE CABLE, CALCUL DU PRODUIT DE MATRICES
!            YT * Y  Y ETANT LA MATRICES DES DERIVEES DES FONCTIONS DE
!            FORME ENPRIM.
!            LE PRODUIT EST CALCULE AUX POINTS DE GAUSS SUCCESSIFS
!            ET RANGE PAR LIGNES: 1ERE LIGNE, PUIS 2EME LIGNE...
!     IN: NNO  : NOMBRE DE NOEUDS
!         NPG  : NOMBRE DE POINTS DE GAUSS
!         DFDE : DERIVEES DES FONCTIONS DE FORME
!     OUT: YTY
! ----------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: i, ii, j, jj, k, ki, ngaus
    integer :: nno, nordre, npg, numero
!-----------------------------------------------------------------------
    k = 0
    do 2 j = 1, npg
        do 1 i = 1, nno
            k = k + 1
            enprim(i,j) = dfde(k)
 1      continue
 2  end do
!
    nordre = 3 * nno
    numero = -nordre
    do 14 ngaus = 1, npg
        do 13 ii = 1, nno
            do 12 ki = 1, 3
                i = ki + 3*(ii-1)
                numero = numero + nordre
                do 11 jj = 1, nno
                    j = ki + 3*(jj-1)
                    yty(numero + j) = enprim(ii,ngaus) * enprim(jj, ngaus)
11              continue
12          continue
13      continue
14  end do
end subroutine
