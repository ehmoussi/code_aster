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

subroutine gedisc(ndim, nno, npg, vff, geom,&
                  pg)
!
    implicit none
#include "blas/ddot.h"
    integer :: ndim, nno, npg
    real(kind=8) :: vff(nno, npg), geom(ndim, nno), pg(ndim+1, npg)
! ----------------------------------------------------------------------
!             CALCUL DES COORDONNEES DES POINTS DE GAUSS
! ----------------------------------------------------------------------
! IN  NDIM   DIMENSION DE L'ESPACE
! IN  NNO    NOMBRE DE NOEUDS
! IN  NPG    NOMBRE DE POINTS DE GAUSS
! IN  VFF    VALEUR DES FONCTIONS DE FORME
! IN  GEOM   COORDONNEES DES NOEUDS
! OUT PG     COORDONNEES DES POINTS DE GAUSS + POIDS
! ----------------------------------------------------------------------
    integer :: g, i
! ----------------------------------------------------------------------
    do 10 g = 1, npg
        do 20 i = 1, ndim
            pg(i,g) = ddot(nno,geom(i,1),ndim,vff(1,g),1)
20      continue
        pg(ndim+1,g) = 0.d0
10  end do
end subroutine
