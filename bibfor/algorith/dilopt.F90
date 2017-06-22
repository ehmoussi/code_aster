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

subroutine dilopt(dimdef, dimuel, poids, poids2, b,&
                  drde, matuu)
! ======================================================================
! aslint: disable=W1306
    implicit none
#include "blas/dgemm.h"
    integer :: dimdef, dimuel
    real(kind=8) :: poids, poids2, drde(dimdef, dimdef), b(dimdef, dimuel)
    real(kind=8) :: matuu(dimuel*dimuel)
! --- BUT : ASSEMBLAGE DE L OPERATEUR TANGENT POUR LA PARTIE -----------
! ---       SECOND GRADIENT POUR L ELEMENT CALCULE ---------------------
! ======================================================================
! --- VARIABLES LOCALES ------------------------------------------------
! ======================================================================
    integer :: i, j, kji
    real(kind=8) :: matr1(dimdef, dimuel), matri(dimuel, dimuel)
! ======================================================================
    do 10 i = 1, dimuel
        do 20 j = 1, dimdef
            matr1(j,i)=0.0d0
20      continue
        do 50 j = 1, dimuel
            matri(j,i)=0.0d0
50      continue
10  end do
! ======================================================================
    call dgemm('N', 'N', dimdef, dimuel, dimdef,&
               1.0d0, drde, dimdef, b, dimdef,&
               0.0d0, matr1, dimdef)
!
    call dgemm('T', 'N', dimuel, dimuel, dimdef,&
               poids, b, dimdef, matr1, dimdef,&
               0.0d0, matri, dimuel)
! ======================================================================
    kji=1
    do 30 i = 1, dimuel
        do 40 j = 1, dimuel
            matuu(kji) = matuu(kji)+matri(i,j)
            kji = kji+1
40      continue
30  end do
! ======================================================================
end subroutine
