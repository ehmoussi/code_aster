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

subroutine calint(i, j, vect1, nbpts, vect2,&
                  long, tt)
    implicit none
#include "jeveux.h"
    integer :: i, j, nbpts
    real(kind=8) :: vect2(nbpts)
    complex(kind=8) :: vect1(long)
!      A PARTIR DES VALEURS DE FONCTIONS CALCULE L'INTERSPECTRE  OU
!           L'AUTOSPECTRE
!     ----------------------------------------------------------------
!     IN  : VECT1 : VECTEUR DES VALEURS DES FONCTIONS DANS LE DOMAINE
!                   FREQUENTIEL
!     OUT : VECT2 : VALEURS DES AUTOSPECTRES ET INTERSPECTRES
!           NBPTS : NOMBRE DE POINTS DE LA DISCRETISATION FREQUENTIELLE
!           TT    : TEMPS TOTAL DE L'EVOLUTION TEMPORELLE
!
!-----------------------------------------------------------------------
    integer :: k, long, lvect1, lvect2, npt, npt2
    real(kind=8) :: tt
!-----------------------------------------------------------------------
    npt= nbpts
    npt2 = npt/2
    do 10 k = 1, npt2
        lvect1 = (i-1)*npt2+ k
        lvect2 = (j-1)*npt2+ k
        vect2(k) =(dble(vect1(lvect1)*dconjg(vect1(lvect2))))/tt
        vect2(npt2+k)=(dimag(vect1(lvect1)*dconjg(vect1(lvect2))))/tt
10  end do
end subroutine
