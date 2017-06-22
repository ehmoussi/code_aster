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

subroutine calcj0(t, sigpri, valp)
    implicit none
!     CALCUL LE MAXIMUM DES :
!                        . CONTRAINTES PRINCIPALES      (= 3 VALEURS)
!     AU MOYEN DE LA METHODE ITERATIVE DE JACOBI (ROUTINE JACOBI.F )
!     LE CALCUL EST EN DIM 3 (COHERENT AVEC CHOIX DE NMVPRK)
! ----------------------------------------------------------------------
!     IN     T     TENSEUR CONTRAINTE OU DEFORMATION (XX YY ZZ XY XZ YZ)
!            ON EST EN DIMENSION ESPACE = 3
!     OUT    VALP  VECTEUR DES GRANDEURS EQUIVALENTES
! ----------------------------------------------------------------------
#include "asterfort/jacobi.h"
    real(kind=8) :: t(6), tb(6), ts(6), tu(6), vecp(3, 3)
    real(kind=8) :: valp(3), jacaux(3)
    real(kind=8) :: tol, toldyn
    real(kind=8) :: sigpri
    integer :: nbvec, nperm
    integer :: i, itype, iordre
!-----------------------------------------------------------------------
    integer :: nitjac
!-----------------------------------------------------------------------
    data   nperm ,tol,toldyn    /12,1.d-10,1.d-2/
! ----------------------------------------------------------------------
!     ON RECALCULE LES TERMES REELS DU TENSEURS SACHANT
!     QUE LES TERMES NON DIAGONAUX ONT ETE MULTIPLIE PAR SQRT(2)
!
    do 30 i = 1, 6
        tb(i)=t(i)
!      IF (I.GT.3) TB(I)=T(I)/RAC2
30  end do
!
!     REANRANGEMENT POUR LA ROUTINE JACOBI EN COLONNE
!     A=(XX YY ZZ XY XZ YZ)->B=(XX XY XZ YY YZ ZZ)
!
    ts(1)=tb(1)
    ts(2)=tb(4)
    ts(3)=tb(5)
    ts(4)=tb(2)
    ts(5)=tb(6)
    ts(6)=tb(3)
!
!     MATRICE UNITE = (1 0 0 1 0 1) (POUR JACOBI)
    tu(1) = 1.d0
    tu(2) = 0.d0
    tu(3) = 0.d0
    tu(4) = 1.d0
    tu(5) = 0.d0
    tu(6) = 1.d0
!
! -    VALEURS PRINCIPALES
    nbvec = 3
    itype = 2
    iordre = 2
    call jacobi(nbvec, nperm, tol, toldyn, ts,&
                tu, vecp, valp(1), jacaux, nitjac,&
                itype, iordre)
!
    sigpri=max(valp(1),valp(2),valp(3))
!
end subroutine
