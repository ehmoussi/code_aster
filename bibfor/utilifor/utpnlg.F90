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

subroutine utpnlg(nno, ndim, pgl, matl,mate)
    implicit none
#include "asterfort/r8inir.h"
    integer      :: nno, ndim
    real(kind=8) :: mate(1), pgl(ndim, ndim), matl(nno*ndim,nno*ndim)
! .....................................................................C
! .....................................................................C
!    - FONCTION REALISEE:  TRANSFORMATION DES MATRICES ELEMENTAIRES    C
!                          PASSAGE DU REPERE LOCAL AU REPERE GLOBAL    C
!    - ARGUMENTS:                                                      C
!        DONNEES:      MATE    -->  MATRICE ELEMENTAIRE                C
!                      PGL     -->  MATRICE DE PASSAGE L -> G          C
!                      NI      -->  DIMENTION DU PREMIER INDICE        C
!                      NJ      -->  DIMENTION DU DEUXIEME INDICE       C
!        SORTIE :      MATE    -->  MATRICE ELEMENTAIRE GLOBALE        C
! .....................................................................C
! .....................................................................
    integer :: i, j, k, ii,nj
    real(kind=8) :: mt(nno*ndim, nno*ndim), matg(nno*ndim, nno*ndim)
! .....................................................................
    nj=nno*ndim
! --- MATRICE DE TRANSFERT
    call r8inir(nno*nno*ndim*ndim,0.d0,mt,1)
    do 10 i = 1, ndim
        do 20 j = 1, ndim
           do 30 k = 0, nno-1
             mt(i ,j ) = pgl(i,j)
             mt(i+k*ndim,j+k*ndim) = pgl(i,j)
30         continue
20      continue
10  continue
!
! --- ON EFFECTUE : MATG() = MATE() * MT()
    do 40 k = 1, nno*ndim
        do 50 i = 1, nno*ndim
            matg(i,k) = 0.d0
            do 60 j = 1, nj
                matg(i,k) = matg(i,k) + matl(i,j) * mt(j,k)
60          continue
50      continue
40  continue
! --- MULTIPLICATION PAR LA MATRICE TRANSPOSEE DE "MT" LORSQUE
!           "MATE" EST RECTANGULAIRE DE DIMENSIONS 7X7
      do 70 i = 1, nno*ndim
          ii = nj * (i-1)
          do 80 k = 1, nno*ndim
              mate(ii+k) = 0.d0
              do 90 j = 1, nj
                  mate(ii+k) = mate(ii+k) + mt(j,i)*matg(j,k)
90            continue
80        continue
70    continue
! .....................................................................
end subroutine
