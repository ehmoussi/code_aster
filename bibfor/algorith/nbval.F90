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

subroutine nbval(ck, cm, cmat, ndim, lambda,&
                 nb)
!    B. GUIGON   P. RICHARD                    DATE 06/04/92
!-----------------------------------------------------------------------
!  BUT:  < CALCULER LE NOMBRE DE VALEUR PROPRES INFERIEURES A LAMBDA
    implicit none
!          D'UN  PROBLEME HERMITIEN >
!
!   CALCULER LE NOMBRE DE VALEURS PROPRES INFERIEURES A LAMBDA D'UN
!   PROBLEME HERMITIEN
!                     CK*X= L CM*X
!-----------------------------------------------------------------------
!
! CK       /I/: MATRICE RAIDEUR DU PROBLEME
! CM       /I/: MATRICE MASSE DU PROBLEME
! NDIM     /I/: DIMENSION DES MATRICES
! LAMBDA   /I/: VOIR DESCRIPTION DE LA ROUTINE
! NB       /O/: NOMBRE DE VALEURS PROPRES
!
!-----------------------------------------------------------------------
!
#include "asterfort/trldc.h"
    integer :: ndim, nb
    complex(kind=8) :: ck(*), cm(*), cmat(*)
    real(kind=8) :: lambda
    integer :: i, ipivo
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!
!      INITIALISATION DE LA MATRICE K-LAMBDA*M
!
!-----------------------------------------------------------------------
    integer :: idiag
!-----------------------------------------------------------------------
    do 10 i = 1, ndim*(ndim+1)/2
        cmat(i)=ck(i)-lambda*cm(i)
10  end do
!
!    FACTORISATION DE LA MATRICE
!
    call trldc(cmat, ndim, ipivo)
!
!    COMPTAGE DU NOMBRE DE TERME NEGATIF SUR LA DIAGONALE DE 'D'
!    DANS LA DECOMPOSTION LDLT DE LA MATRICE
!
    nb=0
    do 20 i = 1, ndim
        idiag = i*(i-1)/2+1
        if (dble(cmat(idiag)) .lt. 0.d0) nb=nb+1
20  end do
!
end subroutine
