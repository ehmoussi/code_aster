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

subroutine diares(n, nevec, a, lda, tau,&
                  evec, ldevec, work)
    implicit none
#include "asterfort/zaddrc.h"
#include "asterfort/zmulmv.h"
#include "asterfort/zmult.h"
    integer :: n, nevec, lda, ldevec
    complex(kind=8) :: a(lda, *), tau(*), evec(ldevec, *), work(*)
!      REDUCTION D'UNE MATRICE HERMITIENNE EN UNE MATRICE TRIDIAGONALE
!          SYMETRIQUE (METHODE DE HOUSEHOLDER).
!-----------------------------------------------------------------------
! IN  : N    : DIMENSION DES MATRICES.
!     : NEVEC: NOMBRE DE VECTEURS PROPRES A DETERMINER
!     : A    : MATRICE COMPLEXE D'ORDRE N. SEULE LA PARTIE TIANGULAIRE
!              INFERIEURE DE LA MATRICE DE HOUSEHOLDER EST STOCKEE.
!     : LDA  : DIMENSION DE A
!     : TAU  : VECTEUR COMPLXE DE DIMENSION N, CONTENANT LA DIAGONALE
!              DE LA MATRICE UNITAIRE T.
! I/O : EVEC : MATRICE COMPLEXE D'ORDRE N.
!         IN : CONTIENT LES VECTEURS PROPRES DE LA MATRICE TRIDIAGONALE
!        OUT : CONTIENT LES VECTEURS PROPRES DE LA MATRICE INITIALE.
! IN  :LDEVEC: DIMENSION DE LA MATRICE EVEC.
! OUT : WORK : VECTEUR COMPLEXE (ZONE DE TRAVAIL).
!-----------------------------------------------------------------------
    integer :: j, nr
    real(kind=8) :: delta
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    do 10 j = 2, n
        call zmult(nevec, dconjg(tau(j)), evec(j, 1), ldevec)
10  end do
!
!  --- STOCKAGE DE LA MATRICE DE HOUSEHOLDER DANS L'ORDRE INVERSE ---
    do 20 nr = n - 1, 2, -1
        delta = dimag(a(nr,nr))*abs(a(nr,nr-1))
        if (delta .ne. 0.0d0) then
            call zmulmv('CONJUGATE', n-nr+1, nevec, (1.0d0, 0.0d0), evec(nr, 1),&
                        ldevec, a(nr, nr-1), 1, (0.0d0, 0.0d0), work,&
                        1)
            call zaddrc(n-nr+1, nevec, dcmplx(-1.0d0/delta, 0.0d0), a(nr, nr-1), 1,&
                        work, 1, evec(nr, 1), ldevec)
        endif
20  end do
end subroutine
