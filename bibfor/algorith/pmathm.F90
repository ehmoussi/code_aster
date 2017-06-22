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

subroutine pmathm(dimmat, dimdef, dimcon, dimuel, dsde,&
                  drds, ck, b, poids, matri)
! aslint: disable=W1306
    implicit   none
    integer :: dimdef, dimcon, dimuel, dimmat
    real(kind=8) :: dsde(dimcon, dimdef), drds(dimdef, dimcon), poids
    real(kind=8) :: ck(dimdef), b(dimdef, dimuel), matri(dimmat, dimmat)
! ======================================================================
! --- BUT : PRODUIT DES MATRICES BT,C,DRDS,D,DSDE,F,B*POIDS ------------
! ---       CONTRIBUTION DU POINT D'INTEGRATION A DF -------------------
! ---       C,F,D SONT DIAGONALES --------------------------------------
! ======================================================================
    integer :: i, j, k
    real(kind=8) :: g(dimcon, dimuel), h(dimdef, dimuel)
! ======================================================================
! --- ON FAIT LE CALCUL EN TROIS FOIS ----------------------------------
! ======================================================================
    do 10 i = 1, dimcon
        do 20 j = 1, dimuel
            g(i,j) = 0.d0
            do 30 k = 1, dimdef
                g(i,j) = g(i,j) + dsde(i,k)*b(k,j)
30          continue
20      continue
10  continue
    do 40 i = 1, dimdef
        do 50 j = 1, dimuel
            h(i,j)= 0.d0
            do 60 k = 1, dimcon
                h(i,j) = h(i,j) + ck(i)*drds(i,k)*g(k,j)
60          continue
50      continue
40  continue
    do 70 i = 1, dimuel
        do 80 j = 1, dimuel
            do 90 k = 1, dimdef
                matri(i,j) = matri(i,j) + b(k,i)*h(k,j)*poids
90          continue
80      continue
70  continue
! ======================================================================
end subroutine
