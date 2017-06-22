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

subroutine genale(vec1, vec2, r, v, x,&
                  dim, long, lonv, ln)
    implicit none
!     IN  : VEC1  : VECTEUR DES VALEURS DE LA MATRICE INTERSPECTRALE
!     OUT : VEC2  : VALEURS DES FONCTIONS GENEREES POUR UN TIRAGE
!           R     : MATRICE DE TRAVAIL (MATR. INTERSP. POUR UNE FREQ.)
!           V     : VECTEUR DE TRAVAIL (VALEURS DES FONCTIONS GENEREES)
!           X     : VECTEUR DE TRAVAIL (BRUIT BLANC)
!                               V(FREQ) = R(FREQ) * X(FREQ)
!           DIM   : DIMENSION DE LA MATRICE DE TRAVAIL
!           LN    : NOMBRE DE POINTS DE LA DISCRETISATION
!           NALEA : NOMBRE ALEATOIRE POUR INITIALISER LE GENERATEUR
#include "jeveux.h"
#include "asterfort/genere.h"
    integer :: dim, long, lonv
    real(kind=8) :: vec1(long), vec2(lonv)
    complex(kind=8) :: r(dim, dim), v(dim), x(dim)
!     ------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: i, icomp, ix, iy, j, kf, kk
    integer :: ln, ln2
!-----------------------------------------------------------------------
    ln2=ln*2
    do 10 kf = 1, ln
        icomp = 0
        do 20 j = 1, dim
            do 30 i = 1, dim
                icomp = icomp+1
                ix = ln + kf + (icomp-1)*ln2
                iy = ix + ln
                r(i,j) = dcmplx(vec1(ix),vec1(iy))
30          continue
20      continue
        
!
        call genere(r, dim, v, x)
!
        do 40 kk = 1, dim
            ix = kf + (kk-1)*ln2
            iy = ix + ln
            vec2(ix) = dble(v(kk))
            vec2(iy) = dimag(v(kk))
40      continue
10  end do
end subroutine
