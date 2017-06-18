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
                  drds, ck, b, poids, work1, work2, matri)
    implicit   none
#include "blas/dgemm.h"
    integer :: dimdef, dimcon, dimuel, dimmat
    real(kind=8) :: dsde(dimcon, dimdef), drds(dimdef, dimcon), poids
    real(kind=8) :: ck(dimdef), b(dimdef, dimuel)
    real(kind=8) :: work1(dimcon, dimuel), work2(dimdef, dimuel)
    real(kind=8) :: matri(dimmat, dimmat)
! ======================================================================
! --- BUT : PRODUIT DES MATRICES BT,C,DRDS,D,DSDE,F,B*POIDS ------------
! ---       CONTRIBUTION DU POINT D'INTEGRATION A DF -------------------
! ---       C,F,D SONT DIAGONALES --------------------------------------
! ======================================================================
    integer :: i, j
! ======================================================================
! --- ON FAIT LE CALCUL EN QUATRE FOIS ---------------------------------
! ======================================================================
!   WORK1 = DSDE x B
    call dgemm('N', 'N', dimcon, dimuel, dimdef, 1.d0,&
               dsde, dimcon, b, dimdef, 0.d0,&
               work1, dimcon)
!   WORK2 = DRDS x WORK1
    call dgemm('N', 'N', dimdef, dimuel, dimcon, 1.d0,&
               drds, dimdef, work1, dimcon, 0.d0,&
               work2, dimdef)
!   WORK2 = CK x WORK2
    do j = 1, dimuel
        do i = 1, dimdef
            work2(i,j) = ck(i)*work2(i,j)
        end do
    end do
!   MATRI = MATRI + POIDS x Bt x WORK2
    call dgemm('T', 'N', dimuel, dimuel, dimdef, poids,&
               b, dimdef, work2, dimdef, 1.d0,&
               matri, dimmat)
! ======================================================================
end subroutine
