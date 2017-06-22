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

subroutine diago3(tens, vecp, valp)
    implicit none
#include "asterfort/jacobi.h"
    real(kind=8) :: tens(6), valp(3), vecp(3, 3)
!
!              DIAGONALISATION MATRICE 3x3 SYMETRIQUE
!
!  IN
!     TENS   : TENSEUR SOUS LA FORME (XX YY ZZ XY XZ YZ)
!  OUT
!     VECP   : VECTEURS PROPRES
!     VALP   : VALEURS PROPRES
!
! --- ------------------------------------------------------------------
!
    real(kind=8) :: tol, toldyn
    real(kind=8) :: tr(6), tu(6), jacaux(3)
    integer :: nperm, nitjac, ttrij, otrij, nbind
!
    data        nperm , nbind   / 12 , 3 /
    data        tol ,   toldyn  / 1.0d-10 , 1.0d-02/
!     PAS DE TRI
    data        ttrij , otrij   / 2 , 2 /
!
! --- ------------------------------------------------------------------
!
!     MATRICE  TR = (XX XY XZ YY YZ ZZ) POUR JACOBI
    tr(1) = tens(1)
    tr(2) = tens(4)
    tr(3) = tens(5)
    tr(4) = tens(2)
    tr(5) = tens(6)
    tr(6) = tens(3)
!     MATRICE UNITE = (1 0 0 1 0 1) POUR JACOBI
    tu(1) = 1.d0
    tu(2) = 0.d0
    tu(3) = 0.d0
    tu(4) = 1.d0
    tu(5) = 0.d0
    tu(6) = 1.d0
!
    call jacobi(nbind, nperm, tol, toldyn, tr,&
                tu, vecp, valp, jacaux, nitjac,&
                ttrij, otrij)
end subroutine
